BTKit_Con := rec();


BTKit_Con.TupleStab := function(n, fixpoints)
    local fixlist, i, filters, r;
    fixlist := [1..n]*0;
    for i in [1..Length(fixpoints)] do
        fixlist[fixpoints[i]] := i;
    od;
    filters := [{i} -> fixlist[i]];

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
    filters := [{i} -> fixlist[i]];

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

    orbMap := HashMap();
    pointMap := HashMap();

    r := rec(
        name := "InGroup",
        check := {p} -> p in group,
        refine := rec(
            initalise := function(ps)
                local fixedpoints, mapval, points;
                fixedpoints := PS_FixedPoints(ps);
                fillOrbits(fixedpoints);
                points := pointMap[fixedpoints];
                return [{x} -> points[x]];
            end,

            changed := function(ps, rbase)
                local fixedpoints, points, fixedps, fixedrbase, p;
                if rbase = fail then
                    fixedpoints := PS_FixedPoints(ps);
                    fillOrbits(fixedpoints);
                    points := pointMap[fixedpoints];
                    return [{x} -> points[x]];
                else
                    fixedps := PS_FixedPoints(ps);
                    fixedrbase := PS_FixedPoints(rbase);
                    fixedrbase := fixedrbase{[1..Length(fixedps)]};
                    p := RepresentativeAction(group, fixedps, fixedrbase, OnTuples);
                    Info(InfoBTKit, 1,"Find mapping",fixedps,fixedrbase,p);
                    if p = fail then
                        return fail;
                    fi;
                    points := pointMap[fixedrbase];
                    return [{x} -> points[x^p]];
                fi;
            end)
        );
        return r;
    end;
