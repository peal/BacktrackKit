BTKit_Con := rec();


BTKit_Con.TupleStab := function(n, fixpoints)
    local fixlist, i, filters, r;
    fixlist := [1..n]*0;
    for i in [1..Length(fixpoints)] do
        fixlist[fixpoints[i]] := i;
    od;
    filters := [rec(partition := {i} -> fixlist[i])];

    r := rec(
        name := "TupleStab",
        check := {p} -> OnTuples(fixpoints, p) = fixpoints,
        refine := rec(
            initalise := function(ps)
                return filters;
            end)
        );
    return r;
end;

BTKit_Con.SetStab := function(n, fixedset)
    local fixlist, i, filters, r;
    fixlist := BlistList([1..n], fixedset);
    filters := [rec(partition := {i} -> fixlist[i])];

    r := rec(
        name := "SetStab",
        check := {p} -> OnSets(fixedset, p) = fixedset,
        refine := rec(
            initalise := function(ps)
                return filters;
            end)
        );
    return r;
end;

BTKit_Con.InGroup := function(n, group)
    local orbList,fillOrbits, orbMap, pointMap, r;
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
        name := "InGroup",
        check := {p} -> p in group,
        refine := rec(
            initalise := function(ps)
                local fixedpoints, mapval, points;
                fixedpoints := PS_FixedPoints(ps);
                points := fillOrbits(fixedpoints);
                return [rec(partition := {x} -> points[x])];
            end,

            changed := function(ps, rbase)
                local fixedpoints, points, fixedps, fixedrbase, p;
                if rbase = fail then
                    fixedpoints := PS_FixedPoints(ps);
                    points := fillOrbits(fixedpoints);
                    return [rec(partition := {x} -> points[x])];
                else
                    fixedps := PS_FixedPoints(ps);
                    fixedrbase := PS_FixedPoints(rbase);
                    fixedrbase := fixedrbase{[1..Length(fixedps)]};
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
                    return [rec(partition := {x} -> points[x^p])];
                fi;
            end)
        );
        return r;
    end;

BTKit_Con.EltCentralizer := function(n, fixedelt)
    local cycles, cyclepart,
          i, c, s, r,
          fixByFixed, pointMap;

    cyclepart := [];
    cycles := Cycles(fixedelt, [1..n]);
    for c in cycles do
        s := Length(c);
        for i in c do
            cyclepart[i] := s;
        od;
    od;

    fixByFixed := function(pointlist)
        local part, s, p;
#        if IsBound(pointMap[pointlist]) then
#            return pointMap[pointlist];
#        fi;
        if pointlist = [] then return cyclepart; fi;

        part := [1..n] * 0;
        s := 1;
        for p in pointlist do
            if part[p] = 0 then
                repeat
                    part[p] := s;
                    p := p ^ fixedelt;
                    s := s + 1;
                until part[p] <> 0;
            fi;
        od;
        return part;
    end;

    pointMap := HashMap();
    pointMap[[]] := cyclepart;

    r := rec( name := "EltCentralizer",
              check := {p} -> fixedelt ^ p = fixedelt,
              refine := rec( initalise := function(ps)
                               local fixedpoints, mapval, points;
                               fixedpoints := PS_FixedPoints(ps);
                               points := fixByFixed(fixedpoints);
                               return [rec(partition := {x} -> points[x])];
                             end,
                             changed := function(ps, rbase)
                                 local fixedpoints, points, fixedps, fixedrbase, p;
                                 fixedpoints := PS_FixedPoints(ps);
                                 Print("FIXXED: ", fixedpoints, "\n");
                                 if rbase = fail then # We are computing an rbase
                                     fixedpoints := PS_FixedPoints(ps);
                                     Print("rbasefix, ", fixedpoints, "\n");
                                     # if any fixed point in a cycle is fixed the whole cycle is fixed
                                     points := fixByFixed(fixedpoints);
                                     return [rec(partition := {x} -> points[x])];
                                 else
                                     fixedps := PS_FixedPoints(ps);
                                     fixedrbase := PS_FixedPoints(rbase);
                                     fixedrbase := fixedrbase{[1..Length(fixedps)]};
                                     # This can't be right.
                                     p := RepresentativeAction(SymmetricGroup(n), fixedps, fixedrbase, OnTuples);
                                     Info(InfoBTKit, 1, "Find mapping (EltCentralizer):\n"
                                          , "    fixed points:   ", fixedps, "\n"
                                          , "    fixed by rbase: ", fixedrbase, "\n"
                                          , "    map:            ", p);
                                     if p = fail then
                                         return fail;
                                     fi;
                                     points := fixByFixed(fixedrbase);
                                     return [rec(partition := {x} -> points[x^p])];
                                 fi;
                             end ) );
    return r;
end;

