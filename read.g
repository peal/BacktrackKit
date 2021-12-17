#
# BacktrackKit: An extensible, easy to understand backtracking framework
#
# Reading the implementation part of the package.
#

# A store of the BTKit refiners
BTKit_Con := AtomicRecord(rec());

# Private members
_BTKit := AtomicRecord(rec());

ReadPackage( "BacktrackKit", "gap/internal/util.g");

ReadPackage( "BacktrackKit", "gap/stabtree.g");

ReadPackage( "BacktrackKit", "gap/BacktrackKit.gi");
ReadPackage( "BacktrackKit", "gap/canonical.gi");
ReadPackage( "BacktrackKit", "gap/constraint.gi");
ReadPackage( "BacktrackKit", "gap/partitionstack.gi");
ReadPackage( "BacktrackKit", "gap/refiner.gi");
ReadPackage( "BacktrackKit", "gap/tracer.gi");

ReadPackage( "BacktrackKit", "gap/refiners/simple.g");
ReadPackage( "BacktrackKit", "gap/refiners/conjugacyexample.g");
ReadPackage( "BacktrackKit", "gap/refiners/normaliserexample.g");
ReadPackage( "BacktrackKit", "gap/refiners/graphs.g");
ReadPackage( "BacktrackKit", "gap/refiners/canonicalrefiners.g");
ReadPackage( "BacktrackKit", "gap/refiners/tree/tree.g");
