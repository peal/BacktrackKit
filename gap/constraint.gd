#
# BacktrackKit: An extensible, easy to understand backtracking framework
#
# Declarations for constraint objects
#
#! @Chapter Constraints
#!
#! Informally, a __constraint__ is a <K>true</K>/<K>false</K> mathematical
#! property of permutations that is used to define a search problem in the
#! symmetric group. For example, the property could be “belongs to the
#! permutation group G”, or “commutes with the permutation x”, or “maps the set
#! A to the set B”, or “is an automorphism of the digraph D”.

if not IsBoundGlobal("IsConstraint") then
    # Declare `IsConstraint` if Ferret has not already done so
    DeclareCategory("IsConstraint", IsObject);
fi;
DeclareCategoryCollections("IsConstraint");
BindGlobal(
    "ConstraintFamily",
    NewFamily("ConstraintFamily", IsConstraint)
);
DeclareRepresentation(
    "IsConstraintRep",
    IsConstraint and IsComponentObjectRep and IsAttributeStoringRep, []
);
BindGlobal(
    "ConstraintType",
    NewType(ConstraintFamily, IsConstraintRep)
);

DeclareCategory("IsTransporterConstraint", IsConstraint);
DeclareCategory("IsInCosetByGensConstraint", IsConstraint);

# Any constraint must be for a group, a coset of a group, or the empty set
DeclareProperty("IsCosetConstraint", IsConstraint);
DeclareProperty("IsGroupConstraint", IsConstraint);
DeclareProperty("IsEmptyConstraint", IsConstraint);
InstallTrueMethod(HasIsEmptyConstraint, IsCosetConstraint);
InstallTrueMethod(IsCosetConstraint, IsGroupConstraint);

DeclareSynonym("IsStabiliserConstraint", IsTransporterConstraint and IsGroupConstraint);
DeclareSynonym("IsStabilizerConstraint", IsStabiliserConstraint);
DeclareSynonym("IsInGroupByGensConstraint", IsInCosetByGensConstraint and IsGroupConstraint);

# Attributes of all constraints
DeclareAttribute("Representative", IsConstraint);
DeclareAttribute("LargestMovedPoint", IsConstraint);
DeclareAttribute("LargestRelevantPoint", IsConstraint);
DeclareAttribute("ImageFunc", IsConstraint);
DeclareAttribute("Check", IsConstraint);

# Things set at creation for transporter constraints
DeclareAttribute("ActionFunc", IsTransporterConstraint);
DeclareAttribute("SourceObject", IsTransporterConstraint);
DeclareSynonymAttr("LeftObject", SourceObject);
DeclareAttribute("ResultObject", IsTransporterConstraint);
DeclareSynonymAttr("RightObject", ResultObject);
DeclareOperation("Object", [IsStabiliserConstraint]);

# Things set at creation for in-coset constraints
DeclareAttribute("UnderlyingGroup", IsConstraint);

# A record to contain all constraint creator functions and one-off constraints
DeclareGlobalVariable("Constraint");
InstallValue(Constraint, AtomicRecord(rec()));

DeclareGlobalFunction("Constraint.Transport");
DeclareGlobalFunction("Constraint.Stabilise");
DeclareGlobalFunction("Constraint.Stabilize");
DeclareGlobalFunction("Constraint.Normalise");
DeclareGlobalFunction("Constraint.Normalize");
DeclareGlobalFunction("Constraint.Centralise");
DeclareGlobalFunction("Constraint.Centralize");
DeclareGlobalFunction("Constraint.Conjugate");

DeclareGlobalFunction("Constraint.InGroup");
DeclareGlobalFunction("Constraint.InCoset");
DeclareGlobalFunction("Constraint.InRightCoset");
DeclareGlobalFunction("Constraint.InLeftCoset");

DeclareGlobalFunction("Constraint.MovedPoints");
DeclareGlobalFunction("Constraint.LargestMovedPoint");
