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


DeclareGlobalFunction( "BTKit_BuildRBase" );

DeclareGlobalFunction( "BTKit_Backtrack" );

DeclareGlobalFunction( "BTKit_SimpleSearch" );

DeclareGlobalFunction( "BTKit_SimpleSinglePermSearch" );


#! @Description
#! Information about backtrack search.
DeclareInfoClass( "InfoBTKit" );
SetInfoLevel(InfoBTKit, 0);
