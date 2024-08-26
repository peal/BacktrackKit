#
# BacktrackKit: An extensible, easy to understand backtracking framework
#
# Reading the declaration part of the package.
#

# Private members
if not IsBound(_BTKit) then
    _BTKit := AtomicRecord(rec());
fi;

if not IsBound(_BTKit.FilesInit) then
    ReadPackage( "BacktrackKit", "gap/tracer.gd");
    ReadPackage( "BacktrackKit", "gap/partitionstack.gd");
fi;

if not IsBound(_BT_SKIP_INTERFACE) and not IsBound(_BTKit.InitInterface) then
    _BTKit.InitInterface := true;
    ReadPackage( "BacktrackKit", "gap/interface.gd");
fi;

if not IsBound(_BTKit.FilesInit) then
    _BTKit.FilesInit := true;
    ReadPackage( "BacktrackKit", "gap/BacktrackKit.gd");

    ReadPackage( "BacktrackKit", "gap/canonical.gd");
    ReadPackage( "BacktrackKit", "gap/constraint.gd");
    ReadPackage( "BacktrackKit", "gap/refiner.gd");
fi;
