BTKit_GetCandidateCanonicalSolution := function(state)
    local image, i, ps, perm;
    ps := state!.ps;
    # When this is called, the current partition state of ps should be discrete.
    # The candidate solution is the perm that, for each i, maps the value in
    # cell i of the discrete partition of the RBase to the value in cell i of
    # the current (discrete) partition state of ps.
    image := [];
    for i in [1..PS_Points(ps)] do
        image[PS_CellSlice(ps,i)[1]] := i; # TODO: Make less scary! PS_CellSlice(ps, i)[1];
    od;
    Info(InfoBTKit, 2, "Considering mapping: ", ps!.vals, image, PermList(image));
    perm := PermList(image);
    return rec(perm := perm, image := List(state!.conlist, {x} -> x!.image(perm)));
end;

InstallGlobalFunction( CanonicalBacktrack,
    function(state, canonicaltraces, depth, canonical, branchselector)
    local p, found, saved, vals, branchCell, branchPos, v, tracer;

    Info(InfoBTKit, 2, "Partition: ", PS_AsPartition(state!.ps));

    if PS_Fixed(state!.ps) then
        p := BTKit_GetCandidateCanonicalSolution(state);
        Info(InfoBTKit, 2, "Maybe canonical solution? ", p);
        if not IsBound(canonical.image) or p.image < canonical.image then
            canonical.image := p.image;
            canonical.perms := [p.perm];
        elif IsBound(canonical.image) and p.image = canonical.image then
            Add(canonical.perms, p.perm);
        fi;
        return false;
    fi;

    branchCell := branchselector(state!.ps);
    branchPos := Minimum(PS_CellSlice(state!.ps, branchCell));

    # <vals> is the cell of the current state with index <branchInfo.cell>. We
    # branch by splitting the search space up into those permutations that map
    # <branchInfo.branchPos> to <v>, for each <v> in <vals>.
    vals := Set(PS_CellSlice(state!.ps, branchCell));
    Info(InfoBTKit, 1,
         StringFormatted("Branching at depth {}: {}", depth, branchCell));
    Print("\>");


    for v in vals do
        Info(InfoBTKit, 2, StringFormatted("Branch: {}", v));
        if IsBound(canonicaltraces[depth]) then
            tracer := CanonicalisingTracerFromTracer(canonicaltraces[depth]);
        else
            tracer := EmptyCanonicalisingTracer();
        fi;
        found := false;

        if not BTKit_Stats_AddNode() then
            return false;
        fi;

        # Split off point <v>, and then continue the backtrack search.
        saved := SaveState(state);

        if PS_SplitCellByFunction(state!.ps, tracer, branchCell, {x} -> x = v)
           and RefineConstraints(state, tracer, false) then
                if tracer!.improvedTrace = true then
                    # We improved the canonical image!
                    canonicaltraces[depth] := tracer;
                    canonicaltraces := canonicaltraces{[1..depth]};
                fi;
                if CanonicalBacktrack(state, canonicaltraces, depth + 1, canonical, branchselector) then
                    found := true;
                fi;
        fi;
        RestoreState(state, saved);
    od;
    Print("\<");
    return false;
end);


_BTKit.SimpleCanonicalSearch := 
    function(state)
        local canonical, tracer;
        canonical := rec(perms := []);
        BTKit_ResetStats();

        tracer := EmptyCanonicalisingTracer();
        FirstFixedPoint(state, tracer, false);

        CanonicalBacktrack(state, [], 1, canonical, state!.config.cellSelector);
        return canonical;
    end;


BTKit_SimpleCanonicalSearch :=
    function(ps, conlist, conf...)
        local ret;
        ret := _BTKit.SimpleCanonicalSearch(_BTKit.BuildProblem(ps, conlist, conf));
        return ret;
end;

