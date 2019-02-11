#! @Chapter Ordered tracer
#!
#! An <E>ordered tracer</E> is an ordered partition which supports
#! splitting a cell, and then later undoing a change, reverting the
#! partition back to an earlier state.


#! @Section API
#!
#! @Description
#! Constructor for tracers.
#! @Arguments
#! @Returns a tracer which records the state.
DeclareGlobalFunction("RecordingTracer");

#! @Description
#! Constructor for tracers.
#! @Arguments
#! @Returns a tracer which follows a previous tracer.
DeclareGlobalFunction("FollowingTracer");

#! @Description
#! Constructor for tracers.
#! @Arguments
#! @Returns a tracer which produces a canonical image.
DeclareGlobalFunction("CanonicalisingTracer");


#! @Description
#! Category of tracers.
DeclareCategory("IsTracer", IsObject);
BindGlobal( "TracerFamily", NewFamily("TracerFamily") );


DeclareRepresentation( "IsRecordingTracerRep", IsTracer and IsComponentObjectRep, []);
BindGlobal( "RecordingTracerType", NewType(TracerFamily, IsRecordingTracerRep));
BindGlobal( "RecordingTracerTypeMutable", NewType(TracerFamily,
                                        IsRecordingTracerRep and IsMutable));

DeclareRepresentation( "IsFollowingTracerRep", IsTracer and IsComponentObjectRep, []);
BindGlobal( "FollowingTracerType", NewType(TracerFamily, IsFollowingTracerRep));
BindGlobal( "FollowingTracerTypeMutable", NewType(TracerFamily,
                                        IsFollowingTracerRep and IsMutable));

DeclareRepresentation( "IsCanonicalisingTracerRep", IsTracer and IsComponentObjectRep, []);
BindGlobal( "CanonicalisingTracerType", NewType(TracerFamily, IsCanonicalisingTracerRep));
BindGlobal( "CanonicalisingTracerTypeMutable", NewType(TracerFamily,
                                        IsCanonicalisingTracerRep and IsMutable));

#! @Description
#! Add an event to the trace.
#!
#! @Returns a boolean, which indicates whether the event is accepted by the
#! trace.
DeclareOperation("AddEvent", [IsTracer, IsObject]);

#! @Description
#! Get the length of a trace.
DeclareOperation("TraceLength", [IsTracer]);

#! @Description
#! Get the list of events in the trace.
DeclareOperation("TraceEvent", [IsTracer, IsPosInt]);

DeclareInfoClass("InfoTrace");
SetInfoLevel(InfoTrace, 0);

# This adds a horribly hacky "customisation point", for me to play with.
MaybeAddEvent := function(t, o) return AddEvent(t, o); end;
