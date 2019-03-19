# Any refiner which can be expressed as "stabilize an ordered partition"
# can be implemented easily and efficently, as we only need to handle
# the root node of search (as we never gain more information as search
# progresses).
# Therefore we have two general functions which implement:
#
# MakeFixlistStabilizer: Returns the refiner which implements
#                        fixlist[i] = fixlist[i^p]
#
# MakeFixListTransporter: Returns the refiner which implements
#                         fixlistL[i] = fixlistR[i^p]
#
# These are used to then implement refiners for sets, tuples
# and ordered partitions.


# The minimal requirements of a refiner -- give a 
# name, a 'check' function, and an empty record called 'refine'
BTKit_Con.MostBasicConjugacyTransporter := function(permL, permR)
    return rec(
        name := "MostBasicConjugacy",
        check := {p} -> (permL^p = permR),
        refine := rec()
    );
end;

# Slightly cleverer refiner -- the function 'initalise' is called
# once at the start of search. It should return a function
BTKit_Con.BasicConjugacyTransporter := function(permL, permR)
    local mapToOrbitSize;

    mapToOrbitSize := function(p,n)
        local cycles, list, c, i;
        list := [];
        cycles := Cycles(p, [1..n]);
        for c in cycles do
            for i in c do
                list[i] := Size(c);
            od;
        od;
        return {x} -> list[x];
    end;

    return rec(
        name := "BasicConjugacy",
        check := {p} -> (permL^p = permR),
        refine := rec(
            initalise := function(ps, buildingRbase)
                if buildingRbase then
                    return mapToOrbitSize(permL, PS_Points(ps));
                else
                    return mapToOrbitSize(permR, PS_Points(ps));
                fi;
            end)
    );
end;
