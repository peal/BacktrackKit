#
# BacktrackKit: An extensible, easy to understand backtracking framework
#
# Implementations
#

# The following few lines provide tools to collect statistics about a backtrack
# search. These are stored in the record _BTKit.Stats. Currently, the counter
# _BTKit.Stats.nodes is incremented via BTKit_Stats_AddNode each time the main
# recursive search function Backtrack is entered, and so it counts the
# size of the search. This counter is reset manually, with BTKit_ResetStats.
BTKit_ResetStats := function()
    _BTKit.Stats := rec( nodes := 0, badSolutions := 0 );
end;

BTKit_ResetStats();

BTKit_NodeLimit := infinity;
BTKit_Stats_AddNode := function()
    _BTKit.Stats.nodes := _BTKit.Stats.nodes + 1;
    return _BTKit.Stats.nodes < BTKit_NodeLimit;
end;


InstallMethod(SaveState, [IsBTKitState],
    function(state)
        local refiners;
        if IsBound(state!.graphs) then Error("???"); fi;

        refiners := List(state!.conlist, SaveState);
        return rec(depth := PS_Cells(state!.ps),
                   refiners := refiners
                  );
end);

InstallMethod(RestoreState, [IsBTKitState, IsObject],
    function(state, saved)
        local c;
        if IsBound(state!.graphs) then Error("???"); fi;
        PS_RevertToCellCount(state!.ps, saved.depth);
        for c in [1..Length(saved.refiners)] do
            RestoreState(state!.conlist[c], saved.refiners[c]);
        od;
end);

#! @Description
#! Split the cells of the partition stack <A>ps</A>, if possible, according
#! to a given <A>filter</A>. If the filter is <K>fail</K>, or if the split is
#! rejected by the <A>tracer</A>, then this function returns <K>false</K>.
#! Otherwise, the split is applied and is consistent with the <A>tracer</A>,
#! and this function returns <K>true</K>.
#!
#! @Arguments ps, tracer, filter
#! @Returns <K>true</K> or <K>false</K>.
InstallMethod(ApplyFilters, [IsBTKitState, IsTracer, IsObject],
  function(state, tracer, filter)
    if filter = fail then
        Info(InfoBTKit, 1, "Failed filter");
        return false;
    elif IsFunction(filter) then
        if not PS_SplitCellsByFunction(state!.ps, tracer, filter) then
            Info(InfoBTKit, 1, "Trace violation");
            return false;
        fi;
    else
        ErrorNoReturn("Invalid filter?");
    fi;
    return true;
end);

#! @Description
#! Refine the partition stack <C><A>state</A>.ps</C> according to the list of
#! constraints in <C><A>state</a>.conlist</C>, until it is not possible to use
#! them to refine the current partition stack any further, or until the branch
#! of search becomes inconsistent with the RBase. In the former case, this
#! function returns <K>true</K>, and in the latter case, this function returns
#! <K>false</K>.
#!
#! During RBase creation, the second argument <A>tracer</A> must be
#! a recording tracer, and the third argument <A>rbase</A> must be <K>true</K>.
#! During search, the second argument should be a tracer following the
#! corresponding RBase tracer, and the third argument <A>rbase</A> should be
#! <K>false</K>.
#!
#! @Arguments state, tracer, rbase
#! @Returns <K>true</K> or <K>false</K>.
RefineConstraints := function(state, tracer, rbase)
    local c, filters, cellCount;
    cellCount := -1;
    Info(InfoBTKit, 3, "Refining Constraints");
    while cellCount <> PS_Cells(state!.ps) do
        cellCount := PS_Cells(state!.ps);
        for c in state!.conlist do
            if IsBound(c!.refine.changed) then
                filters := c!.refine.changed(state!.ps, rbase);
                if not ApplyFilters(state, tracer, filters) then
                    return false;
                fi;
            fi;
        od;
        if not ConsolidateState(state, tracer) then
            return false;
        fi;
    od;
    return true;
end;

#! @Description
#! Set up the list of constraints in <C><A>state</A>.conlist</C>, using their
#! <C>refine.initialise</C> members. This should be called once at the start of
#! RBase creation, and once at the start of search. During search, if the branch
#! of search becomes inconsistent with the RBase, then this function returns
#! <K>false</K>. Otherwise, this function returns <K>true</K>.
#!
#! The second and third arguments <A>tracer</A> and <A>rbase</A> should be as in
#! <C>RefineConstraints</C>.
#!
#! @Arguments state, tracer, rbase
#! @Returns <K>true</K> or <K>false</K>.
InitialiseConstraints := function(state, tracer, rbase)
    local c, filters;
    for c in state!.conlist do
        if IsBound(c!.refine.initialise) then
            filters := c!.refine.initialise(state!.ps, rbase);
            if not ApplyFilters(state, tracer, filters) then
                return false;
            fi;
        else
            ErrorNoReturn("constraint <c> has no refine.initialise member,");
        fi;
    od;
    if not ConsolidateState(state, tracer) then
        return false;
    fi;
    return true;
end;

#! @Description
#! Set up a list of constraints. This should be called once, at
#! the start of search after all constraints have been created.
FinaliseRBaseForConstraints := function(state, rbase)
    local c;
    for c in state!.conlist do
        if IsBound(c!.refine.rBaseFinished) then
            c!.refine.rBaseFinished(rbase.ps);
        fi;
    od;
end;

#! @Description
#! Set up the list of constraints using <C>InitialiseConstraints</C>, and
#! then, if successful, refine using <C>RefineConstraints</C>. This
#! function returns true if both of these functions return <K>true</K>.
#!
#! The second and third arguments <A>tracer</A> and <A>rbase</A> should be as in
#! <C>RefineConstraints</C>.
#!
#! @Arguments state, tracer, rbase
#! @Returns <K>true</K> or <K>false</K>.
FirstFixedPoint := function(state, tracer, rbase)
    return InitialiseConstraints(state, tracer, rbase) and
           RefineConstraints(state, tracer, rbase);
end;


#! @Description
#! Return the position of the smallest cell of <A>PS</A> that is not of size 1,
#! or <K>fail</K> if all cells are of size 1. Ties are broken by returning the
#! smallest position.
#!
#! @Arguments PS
#! @Returns a positive integer, or <K>fail</K>.
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

#! @Description
#! Return the position of the cell of <A>PS</A> that is not of size 1
#! which contains the smallest number, or <K>fail</K> if all cells are
#! of size 1.
#!
#! @Arguments PS
#! @Returns a positive integer, or <K>fail</K>.
BranchSelector_MinValueCell := function(ps)
    local cellval, cellpos, i;
    cellval := infinity;
    cellpos := fail;
    for i in [1..PS_Cells(ps)] do
        if Minimum(PS_CellSlice(ps, i)) < cellval and PS_CellLen(ps, i) > 1 then
            cellval := Minimum(PS_CellSlice(ps, i));
            cellpos := i;
        fi;
    od;
    return cellpos;
end;

#! @Description
#! Return the position of the first cell of <A>PS</A> that is not of size 1
#! or <K>fail</K> if all cells are of size 1.
#!
#! @Arguments PS
#! @Returns a positive integer, or <K>fail</K>.
BranchSelector_FirstNonTrivialCell := function(ps)
    local i;
    for i in [1..PS_Cells(ps)] do
        if PS_CellLen(ps, i) > 1 then
            return i;
        fi;
    od;
    return fail;
end;

InstallGlobalFunction( BuildRBase,
    function(state, branchselector)
        local rbase, tracer, saved, branchCell, branchPos;
        saved  := SaveState(state);

        Info(InfoBTKit, 1, "Building RBase");
        Info(InfoBTKit, 2, "RBase level: ", PS_AsPartition(state!.ps));
        tracer := RecordingTracer();
        rbase  := rec(branches := [],
                      root := rec(tracer := tracer)
                     );

        # Initialise the constraints, and use them to refine the initial
        # partition stack as far as possible, to reach a stable point:
        # this is essentially reaching the root node of the search tree.
        # Record the trace into rbase.root.tracer.
        FirstFixedPoint(state, tracer, true);

        # Continue building the RBase until a discrete partition is reached.
        while PS_Cells(state!.ps) <> PS_Points(state!.ps) do

            # Split off the min value of the cell chosen by the branch selector.
            # Use the constraints to refine until the next stable point.
            # Record the trace into a new tracer.
            branchCell := branchselector(state!.ps);
            branchPos := Minimum(PS_CellSlice(state!.ps, branchCell));
            Info(InfoBTKit, 2, "RBase braching: ", branchPos , " in cell ", branchCell, " : ", PS_AsPartition(state!.ps));
            tracer := RecordingTracer();
            # Record the info from this step of construction in rbase.branches.
            Add(rbase.branches, rec(cell   := branchCell,
                                    pos    := branchPos,
                                    tracer := tracer
                                   ));
            PS_SplitCellByFunction(state!.ps, tracer, branchCell, {x} -> (x = branchPos));
            RefineConstraints(state, tracer, true);
            Info(InfoBTKit, 2, "RBase level: ", PS_AsPartition(state!.ps));
        od;

        # When the RBase has been built, save a copy of the corresponding
        # partition stack, and the length of the RBase in search tree.
        rbase.ps := Immutable(state!.ps);
        rbase.depth := Length(rbase.branches);
        Info(InfoBTKit, 1, "RBase built");
        
        _BTKit.Stats.rbase := rbase;

        RestoreState(state, saved);
        return rbase;
    end);

BTKit_GetCandidateSolution := function(ps, rbase)
    local image, i;
    # When this is called, the current partition state of ps should be discrete.
    # The candidate solution is the perm that, for each i, maps the value in
    # cell i of the discrete partition of the RBase to the value in cell i of
    # the current (discrete) partition state of ps.
    image := [];
    for i in [1..PS_Points(ps)] do
        image[PS_CellSlice(rbase.ps, i)[1]] := PS_CellSlice(ps, i)[1];
    od;
    return PermList(image);
end;

BTKit_CheckSolution := function(perm, conlist)
    local check;
    check := ForAll(conlist, c -> c!.check(perm));
    if not check then
        _BTKit.Stats.badSolutions := _BTKit.Stats.badSolutions + 1;
    fi;
    return check;
end;

InstallGlobalFunction( Backtrack,
    function(state, rbase, depth, subgroup, parent_special, find_single, find_gens)
    local p, found, isSol, saved, vals, branchInfo, v, tracer, special;

    Info(InfoBTKit, 2, "Partition: ", PS_AsPartition(state!.ps));

    if depth > Length(rbase.branches) then
        # The current state is as long as the RBase. Therefore no further search
        # will be done here, as the state must always match the RBase.
        # - If the partition state is not discrete, there are no solutions here.
        # - If the partition state is discrete, then this defines a candidate
        #   solution. Construct the candidate, and check it.
        if not PS_Fixed(state!.ps) then
            return false;
        fi;
        p := BTKit_GetCandidateSolution(state!.ps, rbase);
        isSol := BTKit_CheckSolution(p, state!.conlist);
        Info(InfoBTKit, 2, "Maybe solution? ", p, " : ", isSol);
        if isSol then
            subgroup[1] := ClosureGroup(subgroup[1], p);
            Add(subgroup[2], p);
        fi;
        return isSol;
    fi;
    # The current state of search is not yet as long as the RBase, and so we
    # attempt to branch. We consult the RBase to guide this process.

    branchInfo := rbase.branches[depth];
    if PS_Cells(state!.ps) < branchInfo.cell then
        # The current state is inconsistent with the RBase: the RBase branched
        # here on the cell with index <branchInfo.cell>, but the current state
        # has no such cell.
        return false;
    fi;

    # <vals> is the cell of the current state with index <branchInfo.cell>. We
    # branch by splitting the search space up into those permutations that map
    # <branchInfo.branchPos> to <v>, for each <v> in <vals>.
    vals := Set(PS_CellSlice(state!.ps, branchInfo.cell));
    Info(InfoBTKit, 1,
         StringFormatted("Branching at depth {}: {}", depth, branchInfo));
    Print("\>");
    # A node is special if its parent is special, and it is the first one
    # amongst its siblings. If we find a solution at some node, we immediately
    # return to the deepest special node above that node.
    special := parent_special;
    Info(InfoBTKit, 2, StringFormatted(
         "Searching: {}; parent_special: {}", vals, parent_special));

    for v in vals do
        Info(InfoBTKit, 2, StringFormatted("Branch: {}", v));
        tracer := FollowingTracer(rbase.branches[depth].tracer);
        found := false;

        if not BTKit_Stats_AddNode() then
            return false;
        fi;

        # Split off point <v>, and then continue the backtrack search.
        saved := SaveState(state);

        if PS_SplitCellByFunction(state!.ps, tracer, branchInfo.cell, {x} -> x = v)
           and RefineConstraints(state, tracer, false)
           and Backtrack(state, rbase, depth + 1, subgroup, special, find_single, find_gens)
           then
            found := true;
        fi;
        RestoreState(state, saved);

        # If this gave a solution, we return to the deepest special node above.
        # here. If the current node is special, then we are already here, and we
        # should just continue; if the parent node is special, then...
        if found and (find_single or (find_gens and not parent_special)) then
            Print("\<");
            return true;
        fi;
        special := false;
    od;
    Print("\<");
    return false;
end);

_BTKit.DefaultConfig :=
    rec(cellSelector := BranchSelector_MinSizeCell);

_BTKit.FillConfig := function(config, default)
    local ret, r;
    if config = [] then
        return default;
    fi;
    if Length(config) > 1 then
        ErrorNoReturn("Invalid config");
    fi;
    ret := ShallowCopy(default);
    for r in RecNames(config[1]) do
        if not IsBound(ret.(r)) then
            ErrorNoReturn("Invalid argument: ", r);
        fi;
        ret.(r) := config[1].(r);
    od;
    return ret;
end;

_BTKit.BuildProblem :=
   {ps, conlist, conf} -> Objectify(BTKitStateType, rec(ps := ps, conlist := conlist,
                            config := _BTKit.FillConfig(conf, _BTKit.DefaultConfig)));

_BTKit.SimpleSearch :=  
  function(state)
        local rbase, perms, saved, tracer;

        BTKit_ResetStats();
        
        saved := SaveState(state);
        rbase := BuildRBase(state, state!.config.cellSelector);

        FinaliseRBaseForConstraints(state, rbase);
        perms := [ Group(()), [] ];

        tracer := FollowingTracer(rbase.root.tracer);
        if FirstFixedPoint(state, tracer, false) then
            Backtrack(state, rbase, 1, perms, true, false, true);
        fi;
        RestoreState(state, saved);
        return perms[1];
end;

InstallGlobalFunction( BTKit_SimpleSearch,
    {ps, conlist, conf...} -> _BTKit.SimpleSearch(_BTKit.BuildProblem(ps, conlist, conf)));


_BTKit.SimpleSinglePermSearch :=
    function(state, find_single)
        local rbase, perms, saved, tracer;

        BTKit_ResetStats();

        saved := SaveState(state);
        rbase := BuildRBase(state, state!.config.cellSelector);
        FinaliseRBaseForConstraints(state, rbase);
        perms := [ Group(()), [] ];

        tracer := FollowingTracer(rbase.root.tracer);
        if FirstFixedPoint(state, tracer, false) then
            Backtrack(state, rbase, 1, perms, true, find_single, false);
        fi;

        RestoreState(state, saved);

        return perms[2];
end;

InstallGlobalFunction( BTKit_SimpleSinglePermSearch,
    function(ps, conlist, conf...)
    local ret;
    ret := _BTKit.SimpleSinglePermSearch(_BTKit.BuildProblem(ps, conlist, conf), true);
    if IsEmpty(ret) then
        return fail;
    else
        return ret[1];
    fi;
end);

InstallGlobalFunction( BTKit_SimpleAllPermSearch,
    {ps, conlist, conf...} -> _BTKit.SimpleSearch(_BTKit.BuildProblem(ps, conlist, conf)));
