# Any refiner which can be expressed as "stabilize an ordered partition"
# can be implemented easily and efficently, as we only need to handle
# the root node of search (as we never gain more information from such a
# constraint as search progresses).
# Therefore we have two general functions which implement:
#
# MakeFixlistStabilizer: Returns the constraint which implements
#                        fixlist[i] = fixlist[i^p]
#
# MakeFixListTransporter: Returns the constraint which implements
#                         fixlistL[i] = fixlistR[i^p]
#
# These are used to then implement refiners for sets, tuples
# and ordered partitions.

# Make a refiner which accepts permutations p
# such that fixlist[i] = fixlist[i^p]
BTKit_MakeFixlistStabilizer := function(name, fixlist, o, action)
    local filters;
    filters := {i} -> fixlist[i];
    return Objectify(BTKitRefinerType, rec(
        name := name,
        image := {p} -> action(o,p),
        result := {} -> o,
        refine := rec(
            initialise := function(ps, buildingRBase)
                return filters;
            end)
    ));
end;

# Make a refiner which accepts permutations p
# such that fixlistL[i] = fixlistR[i^p]
BTKit_MakeFixlistTransporter := function(name, fixlistL, fixlistR, oL, oR, action)
    local filtersL, filtersR;
    filtersL := {i} -> fixlistL[i];
    filtersR := {i} -> fixlistR[i];
    return Objectify(BTKitRefinerType, rec(
        name := name,
        image := {p} -> action(oL,p),
        result := {} -> oR,
        refine := rec(
            initialise := function(ps, buildingRBase)
                if buildingRBase then
                    return filtersL;
                else
                    return filtersR;
                fi;
            end)
    ));
end;

BTKit_CheckInScope := function(n, list)
    local i;
    for i in list do
        if i < 1 then ErrorNoReturn("Value too small: ", i); fi;
        if i > n then ErrorNoReturn("Value ", i, " above upper bound ", n); fi;
    od;
end;

BTKit_Con.TupleStab := function(n, fixpoints)
    local fixlist, i;
    BTKit_CheckInScope(n, fixpoints);
    fixlist := ListWithIdenticalEntries(n, 0);
    for i in [1..Length(fixpoints)] do
        fixlist[fixpoints[i]] := i;
    od;
    return BTKit_MakeFixlistStabilizer("TupleStab", fixlist, fixpoints, OnTuples);
end;

BTKit_Con.TupleTransporter := function(n, fixpointsL, fixpointsR)
    local fixlistL, fixlistR, i;
    BTKit_CheckInScope(n, fixpointsL);
    BTKit_CheckInScope(n, fixpointsR);
    fixlistL := ListWithIdenticalEntries(n, 0);
    for i in [1..Length(fixpointsL)] do
        fixlistL[fixpointsL[i]] := i;
    od;
    fixlistR := ListWithIdenticalEntries(n, 0);
    for i in [1..Length(fixpointsR)] do
        fixlistR[fixpointsR[i]] := i;
    od;
    return BTKit_MakeFixlistTransporter("TupleTransport", fixlistL, fixlistR, fixpointsL, fixpointsR, OnTuples);
end;

BTKit_Con.SetStab := function(n, fixset)
    local fixlist, i;
    BTKit_CheckInScope(n, fixset);
    fixlist := ListWithIdenticalEntries(n, 0);
    for i in [1..Length(fixset)] do
        fixlist[fixset[i]] := 1;
    od;
    return BTKit_MakeFixlistStabilizer("SetStab", fixlist, fixset, OnSets);
end;

BTKit_Con.SetTransporter := function(n, fixsetL, fixsetR)
    local fixlistL, fixlistR, i;
    BTKit_CheckInScope(n, fixsetL);
    BTKit_CheckInScope(n, fixsetR);
    fixlistL := ListWithIdenticalEntries(n, 0);
    for i in [1..Length(fixsetL)] do
        fixlistL[fixsetL[i]] := 1;
    od;
    fixlistR := ListWithIdenticalEntries(n, 0);
    for i in [1..Length(fixsetR)] do
        fixlistR[fixsetR[i]] := 1;
    od;
    return BTKit_MakeFixlistTransporter("SetTransport", fixlistL, fixlistR, fixsetL, fixsetR, OnSets);
end;

BTKit_Con.OrderedPartitionStab := function(n, fixpart)
    local fixlist, i, j;
    BTKit_CheckInScope(n, Concatenation(fixpart));
    fixlist := ListWithIdenticalEntries(n, 0);
    for i in [1..Length(fixpart)] do
        for j in fixpart[i] do
            fixlist[j] := i;
        od;
    od;
    return BTKit_MakeFixlistStabilizer("OrderedPartitionStab", fixlist);
end;

BTKit_Con.OrderedPartitionTransporter := function(n, fixpartL, fixpartR)
    local fixlistL, fixlistR, i, j;
    BTKit_CheckInScope(n, Concatenation(fixpartL));
    BTKit_CheckInScope(n, Concatenation(fixpartR));
    fixlistL := ListWithIdenticalEntries(n, 0);
    for i in [1..Length(fixpartL)] do
        for j in fixpartL[i] do
            fixlistL[j] := i;
        od;
    od;
    fixlistR := ListWithIdenticalEntries(n, 0);
    for i in [1..Length(fixpartR)] do
        for j in fixpartR[i] do
            fixlistR[j] := i;
        od;
    od;
    return BTKit_MakeFixlistTransporter("OrdredPartitionTransport", fixlistL, fixlistR, fixpartL, fixpartR, OnTuplesSets);
end;


# The following refiner is probably the most complex. It implements
# 'permutation is in group given by list of generators'.
#
# Exactly why this refiner works, and why we use 'RepresentativeAction',
# requires more explanation than fits in this comment. However, every
# other refiner we have ever seen does not need to worry about the values
# in the rBase, so don't use this as a model for another refiner, unless
# that one is also based around a group given as a list of generators.
BTKit_Con.InCoset := function(n, group, perm)
    local orbList,fillOrbits, orbMap, pointMap, r, invperm;
    invperm := perm^-1;
    fillOrbits := function(pointlist)
        local orbs, array, i, j;
        # caching
        if IsBound(pointMap[pointlist]) then
            return pointMap[pointlist];
        fi;

        orbs := Orbits(Stabilizer(group, pointlist, OnTuples), [1..n]);
        orbMap[pointlist] := Set(orbs, Set);
        array := [];
        for i in [1..Length(orbs)] do
            for j in orbs[i] do
                array[j] := i;
            od;
        od;
        pointMap[pointlist] := array;
        return array;
    end;

    # OrbMap is unused?
    orbMap := HashMap();
    pointMap := HashMap();

    r := rec(
        name := "InCoset",
        image := {p} -> RightCoset(group, p),
        result := {} -> RightCoset(group, perm),
        check := {p} -> p in RightCoset(group, perm),
        refine := rec(
            rBaseFinished := function(getRBase)
                r!.RBase := getRBase;
            end,
            initialise := function(ps, buildingRBase)
                local fixedpoints, mapval, points;
                return r!.refine.fixed(ps, buildingRBase);
            end,
            fixed := function(ps, buildingRBase)
                local fixedpoints, points, fixedps, fixedrbase, p;
                if buildingRBase then
                    fixedpoints := PS_FixedPoints(ps);
                    points := fillOrbits(fixedpoints);
                    return {x} -> points[x];
                else
                    fixedps := PS_FixedPoints(ps);
                    fixedrbase := PS_FixedPoints(r!.RBase);
                    fixedrbase := fixedrbase{[1..Length(fixedps)]};

                    if perm <> () then
                        fixedps := OnTuples(fixedps, invperm);
                    fi;

                    p := RepresentativeAction(group, fixedps, fixedrbase, OnTuples);
                    Info(InfoBTKit, 1, "Find mapping (InGroup):\n"
                         , "    fixed points:   ", fixedps, "\n"
                         , "    fixed by rbase: ", fixedrbase, "\n"
                         , "    map:            ", p);
                    
                    
                    if p = fail then
                        return fail;
                    fi;

                    # this could as well call fillOrbits
                    points := pointMap[fixedrbase];
                    if perm = () then
                        return {x} -> points[x^p];
                    else
                        return {x} -> points[x^(invperm*p)];
                    fi;
                fi;
            end)
        );
        return Objectify(BTKitRefinerType, r);
    end;

BTKit_Con.InGroup := {n, group} -> BTKit_Con.InCoset(n, group, ());

#####
#####
#####

##### Code from here is only temporary and will eventually be rewritten or removed.

_BTKit.RefineGraphs := function(points, ps, graphlist)
        local graph, cellcount, hm, v, ret;
        cellcount := -1;
        ret := List([1..points], x -> []);
        for graph in graphlist do
            #Print(graph,"\n");
            for v in [1..points] do
                hm := [];
                hm := List(_BTKit.OutNeighboursSafe(graph, v), {x} -> PS_CellOfPoint(ps, x));
                # We negate to distinguish in and out neighbours ---------v
                Append(hm, List(_BTKit.InNeighboursSafe(graph, v), {x} -> -PS_CellOfPoint(ps, x)));
                #Print(v,":",hm[v],"\n");
                Sort(hm);
                Append(ret[v], hm);
            od;
        od;
        return ret;
end;

BTKit_Con.InCosetWithOrbitals := function(n, group, perm)
    local orbList,fillOrbits, fillOrbitals, orbMap, orbitalMap, pointMap, r, invperm;
    invperm := perm^-1;
    fillOrbits := function(pointlist)
        local orbs, array, i, j;
        # caching
        if IsBound(pointMap[pointlist]) then
            return pointMap[pointlist];
        fi;

        orbs := Orbits(Stabilizer(group, pointlist, OnTuples), [1..n]);
        orbMap[pointlist] := Set(orbs, Set);
        array := [];
        for i in [1..Length(orbs)] do
            for j in orbs[i] do
                array[j] := i;
            od;
        od;
        pointMap[pointlist] := array;
        return array;
    end;

    fillOrbitals := function(pointlist)
        local orbs, array, i, j;
        if IsBound(orbitalMap[pointlist]) then
            return orbitalMap[pointlist];
        fi;

        orbs := _BTKit.getOrbitalList(Stabilizer(group, pointlist, OnTuples), n);
        orbitalMap[pointlist] := orbs;
        return orbs;
    end;

    orbMap := HashMap();
    pointMap := HashMap();
    orbitalMap := HashMap();

    r := rec(
        name := "InGroupWithCoset-BTKit",
        
        image := {p} -> RightCoset(group, p),
        result := {} -> RightCoset(group, perm),
        check := {p} -> p in RightCoset(group, perm),
        refine := rec(
            rBaseFinished := function(getRBase)
                r!.RBase := getRBase;
            end,

            initialise := function(ps, buildingRBase)
                return r!.refine.fixed(ps, buildingRBase);
            end,

            fixed := function(ps, buildingRBase)
                local fixedpoints, points, fixedps, fixedrbase, p, graphs, refinedgraphs;
                if buildingRBase then
                    fixedpoints := PS_FixedPoints(ps);
                    points := fillOrbits(fixedpoints);
                    graphs := fillOrbitals(fixedpoints);
                    Info(InfoBTKit, 5, "Building RBase:", points);
                    refinedgraphs := _BTKit.RefineGraphs(n, ps, graphs);
                    return {x} -> [points[x], refinedgraphs[x]];
                else
                    fixedps := PS_FixedPoints(ps);
                    Info(InfoBTKit, 1, "fixed: ", fixedps);
                    fixedrbase := PS_FixedPoints(r!.RBase);
                    fixedrbase := fixedrbase{[1..Length(fixedps)]};
                    Info(InfoBTKit, 1, "Initial rbase: ", fixedrbase);

                    if perm <> () then
                        fixedps := OnTuples(fixedps, invperm);
                        Info(InfoBTKit, 1, "fixed coset: ", fixedrbase);
                    fi;

                    p := RepresentativeAction(group, fixedps, fixedrbase, OnTuples);
                    Info(InfoBTKit, 1, "Find mapping (InGroup):\n"
                         , "    fixed points:   ", fixedps, "\n"
                         , "    fixed by rbase: ", fixedrbase, "\n"
                         , "    map:            ", p);

                    if p = fail then
                        return fail;
                    fi;

                    points := pointMap[fixedrbase];
                    graphs := orbitalMap[fixedrbase];
                    if perm = () then
                        refinedgraphs := _BTKit.RefineGraphs(n, ps, List(graphs, {g} -> OnDigraphs(g, p^-1)));
                        return {x} -> [points[x^p], refinedgraphs[x]];
                    else
                        Info(InfoBTKit, 5, fixedps, fixedrbase, List([1..n], i -> points[i^(p*invperm)]));
                        refinedgraphs := _BTKit.RefineGraphs(n, ps, List(graphs, {g} -> OnDigraphs(g, (invperm*p)^-1)));
                        return {x} -> [points[x^(invperm*p)], refinedgraphs[x]];
                    fi;
                fi;
            end)
        );
        return Objectify(BTKitRefinerType, r);
    end;

BTKit_Con.InGroupWithOrbitals := {n, group} -> BTKit_Con.InCosetWithOrbitals(n, group, ());
