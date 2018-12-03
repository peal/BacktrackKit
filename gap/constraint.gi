InstallGlobalFunction(BTKit_SaveConstraintState,
    function(conlist)
        local state, i;
        state := [];
        for i in [1..Length(conlist)] do
            if IsBound(conlist[i].btdata) then
                state[i] := StructuralCopy(conlist[i].btdata);
            fi;
        od;
        return state;
    end);

InstallGlobalFunction(BTKit_RestoreConstraintState,
    function(conlist, state)
        local i;
        for i in [1..Length(state)] do
            if IsBound(state[i]) then
                conlist[i].btdata := StructuralCopy(state[i]);
            fi;
        od;
    end);
