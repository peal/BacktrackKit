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

# Slightly cleverer refiner -- the function 'initialise' is called
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
            initialise := function(ps, buildingRbase)
                if buildingRbase then
                    return mapToOrbitSize(permL, PS_Points(ps));
                else
                    return mapToOrbitSize(permR, PS_Points(ps));
                fi;
            end)
    );
end;

# Find the transporter of a permutation under conjugation
BTKit_Con.PermTransporter := function(n, fixedeltL, fixedeltR)
    local cyclepartL, cyclepartR,
          i, c, s, r,
          fixByFixed, pointMap;

    cyclepartL := [];
    for c in Cycles(fixedeltL, [1..n]) do
        s := Length(c);
        for i in c do
            cyclepartL[i] := s;
        od;
    od;

    cyclepartR := [];
    for c in Cycles(fixedeltR, [1..n]) do
        s := Length(c);
        for i in c do
            cyclepartR[i] := s;
        od;
    od;

    fixByFixed := function(pointlist, fixedElt)
        local part, s, p;
        part := [1..n] * 0;
        s := 1;
        for p in pointlist do
            if part[p] = 0 then
                repeat
                    part[p] := s;
                    p := p ^ fixedElt;
                    s := s + 1;
                until part[p] <> 0;
            fi;
        od;
        return part;
    end;


    r := rec( name := "PermTransporter",
              check := {p} -> fixedeltL ^ p = fixedeltR,
              refine := rec( initialise := function(ps, buildingRBase)
                               local points;
                               # Pass cyclepart just on the first call, for efficency
                               if buildingRBase then
                                   points := fixByFixed(PS_FixedPoints(ps), fixedeltL);
                                   return {x} -> [points[x], cyclepartL[x]];
                               else
                                   points := fixByFixed(PS_FixedPoints(ps), fixedeltR);
                                   return {x} -> [points[x], cyclepartR[x]];
                               fi;
                             end,
                             changed := function(ps, buildingRBase)
                               local points;
                               if buildingRBase then
                                    points := fixByFixed(PS_FixedPoints(ps), fixedeltL);
                                else
                                    points := fixByFixed(PS_FixedPoints(ps), fixedeltR);
                                fi;
                               return {x} -> points[x];
                             end) );
    return r;
end;

BTKit_Con.PermCentralizer := function(n, fixedelt)
    return BTKit_Con.PermTransporter(n, fixedelt, fixedelt);
end;
