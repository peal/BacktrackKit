#
# BacktrackKit: An extensible, easy to understand backtracking framework
#
# Methods for refiner objects
#

InstallMethod(SaveState, [IsBTKitRefiner],
    function(con)
        if IsBound(con!.btdata) then
            return StructuralCopy(con!.btdata);
        else
            return fail;
        fi;
    end);

InstallMethod(RestoreState, [IsBTKitRefiner, IsObject],
    function(con, state)
        if state <> fail then
            con!.btdata := StructuralCopy(state);
        fi;
    end);

InstallMethod(DummyRefiner,
    "for a constraint object", [IsConstraint],
    {con} -> Objectify(
        BTKitRefinerType,
        rec(
            name := Concatenation("Dummy refiner for ", Name(con)),
            largest_required_point := LargestRelevantPoint(con),
            constraint := con,
            refine := rec(
                initialise := function(ps, buildingRBase)
                    return {x} -> 1;
                end)
        )
    )
);
