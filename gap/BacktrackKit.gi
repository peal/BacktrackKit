#
# BacktrackKit: An Extensible, easy to understand backtracking framework
#
# Implementations
#


#! @Description
#! Return a small object which can be later used to return to this
#! state from later in the search.
BTKit_SaveState := function(state)
    return rec(depth := PS_Cells(state.ps),
               conState := BTKit_SaveConstraintState(state.conlist),
               );
end;

#! @Description
#! Return to a saved state from later in the search.
BTKit_RestoreState := function(state, saved)
    PS_RevertToCellCount(state.ps, saved.depth);
    BTKit_RestoreConstraintState(state.conlist, saved.conState);
end;

BTKit_ApplyFilters := function(ps, tracer, filter)
    local f, ret;
    if filter = fail then
        Info(InfoBTKit, 1, "Failed filter");
        return false;
    fi;
    if IsFunction(filter) then
        if not PS_SplitCellsByFunction(ps, tracer, filter) then
            Info(InfoBTKit, 1, "Trace violation");
            return false;
        fi;
    else
        ErrorNoReturn("Invalid filter?");
    fi;
    return true;
end;

BTKit_RefineConstraints := function(state, tracer, rbase)
    local c, filters, cellCount;
    cellCount := -1;
    while cellCount <> PS_Cells(state.ps) do
        cellCount := PS_Cells(state.ps);
        for c in state.conlist do
            if IsBound(c.refine.changed) then
                filters := c.refine.changed(state.ps, rbase);
                if not BTKit_ApplyFilters(state.ps, tracer, filters) then
                    return false;
                fi;
            fi;
        od;
    od;
    return true;
end;


#! @Description
#! Set up a list of constraints. This should be called once, at
#! the start of search after all constraints have been created.
BTKit_InitaliseConstraints := function(state, tracer, rbase)
    local c, filters;
    for c in state.conlist do
        if IsBound(c.refine.initalise) then
            filters := c.refine.initalise(state.ps, rbase);
            if not BTKit_ApplyFilters(state.ps, tracer, filters) then
                return false;
            fi;
        fi;
    od;
    return true;
end;

BTKit_FirstFixedPoint := function(state, tracer, rbase)
    return BTKit_InitaliseConstraints(state, tracer, rbase) and
           BTKit_RefineConstraints(state, tracer, rbase);
end;


#! @Description
#! Return the smallest cell of <a>ps</a> which is not of size 1,
#! (or fail if all cells are size 1). Break ties by returning smaller
#! cells.
BranchSelector_MinSizeCell := function(ps)
    local cellsize, cellpos, i;
    cellsize := infinity;
    cellpos := fail;
    for i in [1..PS_Cells(ps)] do
        if PS_CellLen(ps, i) < cellsize and PS_CellLen(ps, i) > 1 then
            cellsize := PS_CellLen(ps, i);
            cellpos := i;
        fi;
    od;
    return cellpos;
end;

InstallGlobalFunction( BTKit_BuildRBase,
    function(state, branchselector)
        local rbase, tracelist, tracer, branchinfo, saved, branchCell, branchPos;
        Info(InfoBTKit, 1, "Building RBase");
        
        saved := BTKit_SaveState(state);

        rbase := rec(branches := []);

        tracer := RecordingTracer();
        rbase.root := rec(tracer := tracer);

        BTKit_FirstFixedPoint(state, tracer, fail);

        while PS_Cells(state.ps) <> PS_Points(state.ps) do
            branchCell := branchselector(state.ps);
            branchPos := Minimum(PS_CellSlice(state.ps, branchCell));
            tracer := RecordingTracer();
            Add(rbase.branches, rec(cell := branchCell,
                                pos := branchPos, tracer := tracer));
            PS_SplitCellByFunction(state.ps, tracer, branchCell, {x} -> (x = branchPos));
            BTKit_RefineConstraints(state, tracer, fail);
            Info(InfoBTKit, 2, "RBase level:", PS_AsPartition(state.ps));
        od;

        rbase.ps := Immutable(state.ps);
        rbase.depth := Length(rbase.branches);

        BTKit_RestoreState(state, saved);
        
        return rbase;
    end);

BTKit_GetCandidateSolution := function(ps, rbase)
    local perm, list1, list2, n, c, i;
    n := PS_Points(ps);
    list1 := List([1..n], {x} -> PS_CellSlice(rbase.ps, x)[1]);
    # At this point the partition stack should be fixed
    list2 := List([1..n], {x} -> PS_CellSlice(ps, x)[1]);
    perm := [];
    for i in [1..n] do
        perm[list1[i]] := list2[i];
    od;
    return PermList(perm);
end;

BTKit_CheckSolution := function(perm, conlist)
    local c;
    for c in conlist do
        if not c.check(perm) then
            return false;
        fi;
    od;
    return true;
end;

InstallGlobalFunction( BTKit_Backtrack,
    function(state, rbase, depth, subgroup, parent_special, find_single_perm)
    local p, found, isSol, saved, vals, branchInfo, v, tracer, special, perms;
    Info(InfoBTKit, 2, "Partition: ", PS_AsPartition(state.ps));

    if depth > Length(rbase.branches) then
        # If we haven't reached fixed everything, this isn't a solution.
        if not PS_Fixed(state.ps) then
            return false;
        fi;
        p := BTKit_GetCandidateSolution(state.ps, rbase);
        isSol := BTKit_CheckSolution(p, state.conlist);
        Info(InfoBTKit, 2, "Maybe solution?",p,":",isSol);
        if isSol then
            subgroup[1] := ClosureGroup(subgroup[1], p);
            Add(subgroup[2], p);
            return true;
        else
            return false;
        fi;
    else
        branchInfo := rbase.branches[depth];
        # If this number is smaller than the number of cells, we aren't branching on it
        if PS_Cells(state.ps) < branchInfo.cell then
            return false;
        fi;
        vals := Set(PS_CellSlice(state.ps, branchInfo.cell));
        Info(InfoBTKit, 1, "Branching: ", depth, ":", branchInfo);
        Print("\>");
        # A node is special if its parent is special and it is
        # the first one amongst its siblings
        # If we find a group element down a subtree
        # we return to the deepest special node above
        special := parent_special;
        Info(InfoBTKit, 2, "Searching: ", vals, " parent_special: ", parent_special, " special: ", special);
        for v in vals do
            Info(InfoBTKit, 2, " Branch: ", v);
            saved := BTKit_SaveState(state);
            
            tracer := FollowingTracer(rbase.branches[depth].tracer);
            found := false;
            if PS_SplitCellByFunction(state.ps, tracer, branchInfo.cell, {x} -> x = v) and
               BTKit_RefineConstraints(state, tracer, rbase.ps) then
                found := BTKit_Backtrack(state, rbase, depth+1, subgroup, special, find_single_perm);
            fi;

            BTKit_RestoreState(state, saved);

            # We found a permutation below so we return to the deepest
            # special node node above
            if found and (find_single_perm or ((not special) and (not parent_special))) then
                Print("\<");
                return true;
            fi;
            special := false;
        od;
        Print("\<");
    fi;
    return false;
end);

InstallGlobalFunction( BTKit_SimpleSearch,
    function(ps, conlist)
        local rbase, perms, state, saved, tracer;
        state := rec(ps := ps, conlist := conlist);
        saved := BTKit_SaveState(state);
        rbase := BTKit_BuildRBase(state, BranchSelector_MinSizeCell);
        perms := [ Group(()), [] ];

        tracer := FollowingTracer(rbase.root.tracer);
        if BTKit_FirstFixedPoint(state, tracer, rbase.ps) then
            BTKit_Backtrack(state, rbase, 1, perms, true, false);
        fi;
        BTKit_RestoreState(state, saved);
        return perms[1];
end);


InstallGlobalFunction( BTKit_SimpleSinglePermSearch,
    function(ps, conlist)
        local rbase, perms, state, saved, tracer;
        state := rec(ps := ps, conlist := conlist);
        saved := BTKit_SaveState(state);
        rbase := BTKit_BuildRBase(state, BranchSelector_MinSizeCell);
        perms := [ Group(()), [] ];

        tracer := FollowingTracer(rbase.root.tracer);
        if BTKit_FirstFixedPoint(state, tracer, rbase.ps) then
            BTKit_Backtrack(state, rbase, 1, perms, true, true);
        fi;

        BTKit_RestoreState(state, saved);

        if Length(perms[2]) > 0 then
            return perms[2][1];
        else
            return fail;
        fi;
end);
