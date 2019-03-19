#
# BacktrackKit: An Extensible, easy to understand backtracking framework
#
#! @Chapter Constraints
#!
#!
#! Constraints are records which must contain:
#!
#! * A member 'name', giving the name of the constraint
#! * A member 'check', which takes two arguments, the constraint
#!   and a permutation, and checks if the permutation satisfies the constraint
#! * A record called <C>refine</C>.
#!
#! <C>refine</C> contains function which, if present,
#! will be called to inform the constraint of behaviour
#! as search progresses. These functions will always
#! be passed at least two arguments -- firstly the
#! constraint itself, then the partition stack. Further
#! arguments are listed below.
#!
#!
#! * initalise - Called when search begins (note, the partition
#!   may already be split, by another constraint)
#!
#! * changed - One or splits occurred
#!
#! * rBaseFinished - The rBase has been created (is passed the RBase).
#!   Constraints which care about this can use this to remember the rBase
#!   construction is finished.
#!
#! Constraints can also contain a member called <C>btdata</C>. This
#! data will be automatically saved and restored on backtrack.

DeclareGlobalFunction("BTKit_SaveConstraintState");

DeclareGlobalFunction("BTKit_RestoreConstraintState");
