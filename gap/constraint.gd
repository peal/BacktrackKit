#
# BacktrackKit: An extensible, easy to understand backtracking framework
#
#! @Chapter Constraints
#!
#! Informally, a <E>constraint</E> is a <K>true</K>/<K>false</K> mathematical
#! property of permutations that is used to define a search problem in the
#! symmetric group. For example, the property could be "belongs to the
#! permutation group G", or "commutes with the permutation x", or "maps set
#! A to set B", or "is an automorphism of the digraph D".
#!
#! In backtrackKit, a constraint is implemented as a record that must contain:
#!
#! * A member called <C>name</C>, which is a string giving the name of the
#!   constraint;
#! * A member called <C>check</C>, which is a function taking two arguments,
#!   the constraint and a permutation, and which checks whether the permutation
#!   satisfies the constraint; and
#! * A member called <C>refine</C>, which is a record; more information is
#!   given below.
#!
#! A constraint may also optionally contain any of the following members:
#!
#! * A member called <C>btdata</C>. The data in this member
#!   will be automatically saved and restored on backtrack.
#!
#! @Section The record <C>refine</C>
#!
#! The <C>refine</C> member of a constraint is a record that contains
#! functions which, if present, will be called to inform the constraint
#! of behaviour as search progresses, and to give the constraint the
#! opportunity to influence the search. The permissible functions are given
#! described below.
#!
#! These functions will always be passed at least two arguments: firstly the
#! constraint itself, and then the partition stack. Details of any further
#! arguments are described with the relevant function, below.
#!
#TODO: the return value of <C>initialise</C> seems to be important.
#! * <C>initialise</C> - This is called when search begins.
#!   Note that, since the <C>refine.initialise</C> function is called for all
#!   relevant constraints at the beginning of search, the partition may have
#!   already been split by some earlier constraint by the time that
#!   <C>refine.initialise</C> is called for a later constraint.
#!
#TODO: this is incomplete
#! * <C>changed</C> - One or splits occurred.
#!
#TODO: this is unclear. Also unimplemented.
#! * <C>rBaseFinished</C> - The rBase has been created (is passed the rBase).
#!   Constraints which care about this can use this to remember the rBase
#!   construction is finished.

DeclareGlobalFunction("BTKit_SaveConstraintState");

DeclareGlobalFunction("BTKit_RestoreConstraintState");
