#
# BacktrackKit: An extensible, easy to understand backtracking framework
#
#! @Chapter Constraints
#!
#! Informally, a __constraint__ is a <K>true</K>/<K>false</K> mathematical
#! property of permutations that is used to define a search problem in the
#! symmetric group. For example, the property could be “belongs to the
#! permutation group G”, or “commutes with the permutation x”, or “maps the set
#! A to the set B”, or “is an automorphism of the digraph D”.
#!
#! In BacktrackKit, a constraint is implemented as a record that must contain:
#!
#! * A member called `name`, which is a string giving the name of the
#!   constraint;
#! * A member called `largest_required_point`, which is an integer
#!   which gives the smallest size partition this refiner will work on.
#!   For example, given a set we would expect this to be the largest element
#!   of the set.
#! * An optional member called `largest_moved_point`, which is an integer
#!   giving an upper bound on the largest point this refiner could ever move.
#!   For many refiners this will not exist -- for example a 'set stabilizer'
#!   refiner will always permute values outside the set.
#! * A member called `refine`, which is a record; more information is
#!   given below.
#!
#! and a method of check permutations, either:
#!
#! * Two members, called `image` and `result`, where `image`
#!   takes a permutation and `result` which is a function which takes
#!   no arguments, where `image(perm)=result` if the permutation satisfies
#!   the constraint
#!
#! Or:
#!
#! * A member called `check`, which is a function taking two arguments,
#!   the constraint and a permutation, and which checks whether the permutation
#!   satisfies the constraint; and
#!
#! `image` and `result` must be implemented for finding canonical
#! images. All 3 functions can be implemented, as long as they are consistent.
#!
#! A constraint may also optionally contain any of the following members:
#!
#! * A member called `btdata`. The data in this member
#!   will be automatically saved and restored on backtrack.
#!
#! @Section The record <C>refine</C>
#!
#! The `refine` member of a constraint is a record that contains
#! functions which, if present, will be called to inform the constraint
#! of behaviour as search progresses, and to give the constraint the
#! opportunity to influence the search. The permissible functions are given
#! described below.
#!
#! These functions will always be passed at least two arguments: firstly the
#! constraint itself, and then the partition stack. Details of any further
#! arguments are described with the relevant function, below.
#!
#TODO: the return value of `initialise` seems to be important.
#! * `initialise` __(required)__. This is called when search begins.
#!   Note that, since the `refine.initialise` function is called for all
#!   relevant constraints at the beginning of search, the partition may have
#!   already been split by some earlier constraint by the time that
#!   `refine.initialise` is called for a later constraint.
#!
#TODO: this is incomplete
#! At most one of the following two functions will generally be implemented.

#! * `changed` - Will be called after one or more splits in the partition occur.
#! * `fixed` - Will be called after one or more points in the partition became fixed.
#!
#TODO: this is unclear. Also unimplemented.
#! * `rBaseFinished` - The rBase has been created (is passed the rbase).
#!   Constraints which care about this can use this to remember the rBase
#!   construction is finished.

DeclareRepresentation("IsBTKitRefiner", IsRefiner, ["name", "check", "refine"]);
BindGlobal("BTKitRefinerType", NewType(BacktrackableStateFamily,
                                       IsBTKitRefiner));

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
