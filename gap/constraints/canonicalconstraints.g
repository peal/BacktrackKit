# For MinimalImagePerm
LoadPackage("images",false);

BTKit_Con.InGroupSimple := function(n, group)
    local orbList,getOrbits, orbMap, pointMap, r, invperm,minperm;

    getOrbits := function(pointlist)
        local orbs, array, i, j, minperm,minpoints,minorbs;
        # caching
        if IsBound(pointMap[pointlist]) then
            return pointMap[pointlist];
        fi;

        minperm := MinimalImagePerm(group, pointlist, OnTuples);
        minpoints := OnTuples(pointlist, minperm);
        minorbs := Orbits(Stabilizer(group, minpoints, OnTuples), [1..n]);
        minorbs := Set(minorbs, Set);
        orbs := OnTuplesSets(minorbs,minperm^-1);

        array := [];

        for i in [1..Length(orbs)] do
            for j in orbs[i] do
                array[j] := i;
            od;
        od;
        #Print(pointlist, minperm, minorbs, orbs,"\n");
        return array;
    end;

    # OrbMap is unused?
    orbMap := HashMap();
    pointMap := HashMap();

    r := rec(
        name := "InGroupSimple",
        image := {p} -> RightCoset(group, p),
        result := {} -> group,
        check := {p} -> p in group,
        refine := rec(
            initialise := function(ps, buildingRBase)
                return r!.refine.changed(ps, buildingRBase);
            end,
            changed := function(ps, buildingRBase)
                local fixedpoints, points;
                fixedpoints := PS_FixedPoints(ps);
                points := getOrbits(fixedpoints);
                return {x} -> points[x];
            end)
        );
        return Objectify(BTKitRefinerType, r);
    end;
