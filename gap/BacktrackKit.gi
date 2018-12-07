#
# BacktrackKit: An Extensible, easy to understand backtracking framework
#
# Implementations
#

BTKit_ApplyFilters := function(ps, tracer, filters)
    local f, ret;
    if filters = fail then
        Info(InfoBTKit, 1, "Failed filter");
        return false;
    fi;
    for f in filters do
        if IsFunction(f.partition) then
            if not PS_SplitCellsByFunction(ps, tracer, f.partition) then
                Info(InfoBTKit, 1, "Trace violation");
                return false;
            fi;
        else
            ErrorNoReturn("Invalid filter?");
        fi;
    od;
    return true;
end;

InitaliseConstraints := function(ps, conlist)
    local c, filters, tracer;
    tracer := RecordingTracer();
    for c in conlist do
        if IsBound(c.refine.initalise) then
            filters := c.refine.initalise(ps);
            if not BTKit_ApplyFilters(ps, tracer, filters) then
                return false;
            fi;
        fi;
    od;
    return true;
end;

BTKit_RefineConstraints := function(ps, tracer, rbase, conlist)
    local c, filters, cellCount;
    cellCount := -1;
    while cellCount <> PS_Cells(ps) do
        cellCount := PS_Cells(ps);
        for c in conlist do
            if IsBound(c.refine.changed) then
                filters := c.refine.changed(ps, rbase);
                if not BTKit_ApplyFilters(ps, tracer, filters) then
                    return false;
                fi;
            fi;
        od;
    od;
    return true;
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
    function(ps, conlist, branchselector)
        local ps_depth, rbase, tracelist, tracer, branchinfo, savedState, branchCell, branchPos;
        Info(InfoBTKit, 1, "Building RBase");
        rbase := rec(branches := []);
        ps_depth := PS_Cells(ps);

        # Make a copy we can keep
        ps := StructuralCopy(ps);

        savedState := BTKit_SaveConstraintState(conlist);
        while PS_Cells(ps) <> PS_Points(ps) do
            branchCell := branchselector(ps);
            branchPos := Minimum(PS_CellSlice(ps, branchCell));
            tracer := RecordingTracer();
            Add(rbase.branches, rec(cell := branchCell,
                                pos := branchPos, tracer := tracer));
            PS_SplitCellByFunction(ps, tracer, branchCell, {x} -> (x = branchPos));
            BTKit_RefineConstraints(ps, tracer, fail, conlist);
            Info(InfoBTKit, 2, "RBase level:", PS_AsPartition(ps));
        od;

        rbase.ps := MakeImmutable(ps);
        rbase.depth := Length(rbase.branches);
        BTKit_RestoreConstraintState(conlist, savedState);
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
    function(ps, rbase, depth, conlist, parent_special)
    local p, isSol, saveState, saveDepth, vals, branchInfo, v, tracer, special, perms;
    Info(InfoBTKit, 2, "Partition: ", PS_AsPartition(ps));

    if depth > Length(rbase.branches) then
        p := BTKit_GetCandidateSolution(ps, rbase);
        isSol := BTKit_CheckSolution(p, conlist);
        Info(InfoBTKit, 2, "Maybe solution?",p,":",isSol);
        if isSol then
            return [ p ];
        else
            return fail;
        fi;
    else
        branchInfo := rbase.branches[depth];
        vals := Set(PS_CellSlice(ps, branchInfo.cell));
        Info(InfoBTKit, 1, "Branching: ", depth, ":", branchInfo);
        Print("\>");
        # A node is special if its parent is spec ial and it is
        # the first one amongst its siblings
        # If we find a group element down a subtree
        # we return to the deepest special node above
        special := parent_special;
        perms := [];
        for v in vals do
            Info(InfoBTKit, 2, "Searching: ", v, " special: ", special);
            saveDepth := PS_Cells(ps);
            saveState := BTKit_SaveConstraintState(conlist);

            tracer := FollowingTracer(rbase.branches[depth].tracer);
            if PS_SplitCellByFunction(ps, tracer, branchInfo.cell, {x} -> x = v) and
               BTKit_RefineConstraints(ps, tracer, rbase.ps, conlist) then
                p := BTKit_Backtrack(ps, rbase, depth+1, conlist, special);

                # We found a permutation below
                if p <> fail then
                    # We found an element so we return to the special
                    # node above
                    if (not parent_special) then
                        PS_RevertToCellCount(ps, saveDepth);
                        BTKit_RestoreConstraintState(conlist, saveState);
                        Print("\<");
                        return p;
                    else
                        Append(perms, p);
                    fi;
                fi;
            fi;

            PS_RevertToCellCount(ps, saveDepth);
            BTKit_RestoreConstraintState(conlist, saveState);
            special := false;
        od;
        Print("\<");
        return perms;
    fi;
end);

InstallGlobalFunction( BTKit_SimpleSearch,
    function(ps, conlist)
        local rbase, perms;
        if not InitaliseConstraints(ps, conlist) then
            return fail;
        fi;
        rbase := BTKit_BuildRBase(ps, conlist, BranchSelector_MinSizeCell);
        perms := BTKit_Backtrack(ps, rbase, 1, conlist, true);
        return perms;
end);
