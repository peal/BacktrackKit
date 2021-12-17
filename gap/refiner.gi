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
