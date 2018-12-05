##
##  This file defines tracers.
##

InstallGlobalFunction(RecordingTracer,
function()
    return Objectify(RecordingTracerTypeMutable, 
        rec(trace := []) );
end);

InstallMethod(AddEvent, [IsRecordingTracerRep and IsMutable, IsObject],
    function(tracer, o)
        Add(tracer!.trace, o);
        return true;
    end);

InstallMethod(TraceLength, [IsRecordingTracerRep], x -> Length(x!.trace));
InstallMethod(TraceEvent, [IsRecordingTracerRep, IsPosInt], {x,i} -> x!.trace[i]);

InstallGlobalFunction(FollowingTracer,
function(trace)
    return Objectify(FollowingTracerTypeMutable, 
        rec(existingTrace := trace, pos := 1) );
end);

InstallMethod(AddEvent, [IsFollowingTracerRep and IsMutable, IsObject],
    function(tracer, o)
        if tracer!.pos > TraceLength(tracer!.existingTrace) then
            Info(InfoTrace, 1, "Too long!");
            return false;
        fi;
        if TraceEvent(tracer!.existingTrace, tracer!.pos) <> o then
            Info(InfoTrace, 1, "Trace violation", TraceEvent(tracer!.existingTrace, tracer!.pos), ":", o);
            tracer!.pos := infinity;
            return false;
        fi;
        tracer!.pos := tracer!.pos + 1;
        return true;
    end);

InstallMethod(TraceLength, [IsFollowingTracerRep], {x} -> TraceLength(x!.existingTrace));
InstallMethod(TraceEvent, [IsFollowingTracerRep, IsPosInt], {x,i} -> TraceEvent(x!.existingTrace, i));

InstallGlobalFunction(CanonicalisingTracer,
function()
    return Objectify(CanonicalisingTracerTypeMutable, 
        rec(trace := [], pos := 1) );
end);
