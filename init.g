#
# BacktrackKit: An extensible, easy to understand backtracking framework
#
# Reading the declaration part of the package.
#

ReadPackage( "BacktrackKit", "gap/tracer.gd");
ReadPackage( "BacktrackKit", "gap/partitionstack.gd");

if not IsBound(_BT_SKIP_INTERFACE) then
    ReadPackage( "BacktrackKit", "gap/interface.gd");
fi;

ReadPackage( "BacktrackKit", "gap/BacktrackKit.gd");

ReadPackage( "BacktrackKit", "gap/canonical.gd");
ReadPackage( "BacktrackKit", "gap/constraint.gd");
ReadPackage( "BacktrackKit", "gap/refiner.gd");
