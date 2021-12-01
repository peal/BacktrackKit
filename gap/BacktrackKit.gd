#
# BacktrackKit: An extensible, easy to understand backtracking framework
#
#! @Chapter Introduction
#!
#! BacktrackKit is a package which does some interesting and cool things.
#!
#! @Chapter Functionality
#!
#!
#! @Section Example methods
#!
#! This section will describe the example methods of BacktrackKit.

DeclareCategory("IsBacktrackableState", IsObject);
BindGlobal("BacktrackableStateFamily", NewFamily("BacktrackableStateFamily", IsBacktrackableState));

DeclareCategory("IsRefiner", IsBacktrackableState);
BindGlobal("RefinerFamily", NewFamily("RefinerFamily", IsRefiner));


#! @Description
#! Return a small object which allows one to revert to this state from later
#! the search. 
#!
#! @Returns The saved state
DeclareOperation("SaveState", [IsBacktrackableState]);

#! @Description
#! Revert to a saved state from later in the search. The first argument
#! <A>state</A> must be the current state object, and the second argument
#! <A>saved</A> must be one of the objects produced by <C>SaveState</C>
#! from earlier in the search.
#!
#! @Arguments state, saved
#! @Returns nothing.
DeclareOperation("RestoreState", [IsBacktrackableState, IsObject]);


#! @Description
#! Some implementations of BacktrackableState can perform simplifications.
#! This function gives a well-defined point for such operations to be
#! performed. It can be ignored by implementations without such simplifications.
DeclareOperation("ConsolidateState", [IsBacktrackableState, IsTracer]);


DeclareRepresentation("IsBTKitState", IsBacktrackableState, []);
BindGlobal("BTKitStateType", NewType(BacktrackableStateFamily,
                                       IsBTKitState));

DeclareOperation("ApplyFilters", [IsBTKitState, IsTracer, IsObject]);


#! @Description
#! Takes a partition stack and a list of constraints and builds a 'Problem',
#! Which can then be solved by passing the 'Problem' to BTKit_SimpleSearch or
#! BT_SimpleSinglePermSearch.
DeclareGlobalFunction( "BTKit_BuildProblem" );

DeclareGlobalFunction( "FirstFixedPoint" );

DeclareGlobalFunction( "BuildRBase" );

DeclareGlobalFunction( "Backtrack" );

DeclareGlobalFunction( "BTKit_SimpleSearch" );

DeclareGlobalFunction( "BTKit_SimpleSinglePermSearch" );

DeclareGlobalFunction( "BTKit_SimpleAllPermSearch" );

#! @Description
#! Information about backtrack search.
DeclareInfoClass( "InfoBTKit" );
SetInfoLevel(InfoBTKit, 0);
