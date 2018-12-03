Con_TupleStab := function(n, fixpoints)
    local fixlist, i, filters;
    fixlist := [1..n]*0;
    for i in [1..Length(fixpoints)] do
        fixlist[fixpoints[i]] := i;
    od;
    filters := [{i} -> fixlist[i]];
    return rec(
        name := "TupleStab",
        points := fixlist,
        check := {p} -> OnTuples(fixpoints, p) = fixpoints,
        refine := rec(
            initalise := function(con, ps)
                return filters;
            end)
        );
end;

Con_SetStab := function(n, fixedset)
    local fixlist, i, filters;
    fixlist := [1..n]*0;
    for i in [1..Length(fixedset)] do
        fixlist[fixedset[i]] := 1;
    od;
    filters := [{i} -> fixlist[i]];
    return rec(
        name := "SetStab",
        fixedset := fixedset,
        check := {p} -> OnSets(fixedset, p) = fixedset,
        refine := rec(
            initalise := function(con, ps)
                return filters;
            end)
        );
end;

Con_InGroup := function(n, group)
    local orbList;
    return rec(
        name := "InGroup",
        group := group,
        orbMap := HashMap(),
        pointMap := HashMap(),
        fillOrbits := function(con, pointlist)
            local orbs, array, i, j;
            if IsBound(con.pointMap[pointlist]) then
                return con.pointMap[pointlist];
            fi;

            orbs := Orbits(Stabilizer(group, pointlist, OnTuples), [1..n]);
            con.orbMap[pointlist] := Set(orbs, Set);
            array := [];
            for i in [1..Length(orbs)] do
                for j in orbs[i] do
                    array[j] := i;
                od;
            od;
            con.pointMap[pointlist] := array;
            return array;
        end,

        check := {p} -> p in group,
        refine := rec(
            initalise := function(con, ps)
                local fixedpoints, mapval, points;
                fixedpoints := PS_FixedPoints(ps);
                con.fillOrbits(con, fixedpoints);
                points := con.pointMap[fixedpoints];
                return [{x} -> points[x]];
            end,

            changed := function(con, ps, rbase)
                local fixedpoints, points, fixedps, fixedrbase, p;
                if rbase = fail then
                    fixedpoints := PS_FixedPoints(ps);
                    con.fillOrbits(con, fixedpoints);
                    points := con.pointMap[fixedpoints];
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
                    points := con.pointMap[fixedrbase];
                    return [{x} -> points[x^p]];
                fi;
            end)
        );
    end;
