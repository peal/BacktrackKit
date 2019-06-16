#
# BacktrackKit: An Extensible, easy to understand backtracking framework
#
# Reading the implementation part of the package.
#

ReadPackage( "BacktrackKit", "gap/tracer.gi");
ReadPackage( "BacktrackKit", "gap/partitionstack.gi");

# A Store of the BTKit constraints
BTKit_Con := AtomicRecord(rec());

# Private members
_BTKit := AtomicRecord(rec());

ReadPackage( "BacktrackKit", "gap/BacktrackKit.gi");
ReadPackage( "BacktrackKit", "gap/constraint.gi");
ReadPackage( "BacktrackKit", "gap/constraints/simpleconstraints.g");
ReadPackage( "BacktrackKit", "gap/constraints/conjugacyexample.g");
ReadPackage( "BacktrackKit", "gap/constraints/graphconstraints.g");
ReadPackage( "BacktrackKit", "gap/constraints/tree/tree.g");
