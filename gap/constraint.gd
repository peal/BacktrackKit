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
#! * A member called <C>refine</C>, which is a record; more information is
#!   given below.
#!
#! and a method of check permutations, either:
#!
#! * Two members, called <C>image</C> and <C>result</C>, where <C>image</C>
#!   takes a permutation and <C>result</C> which is a function which takes
#!   no arguments, where <C>image(perm)=result</C> if the permutation satisfies
#!   the constraint
#!
#! Or:
#!
#! * A member called <C>check</C>, which is a function taking two arguments,
#!   the constraint and a permutation, and which checks whether the permutation
#!   satisfies the constraint; and
#!
#! <C>image</C> and <C>result</C> must be implemented for finding canonical
#! images. All 3 functions can be implemented, as long as they are consistent.
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
#! * <C>initialise</C> <E>(required)</E>. This is called when search begins.
#!   Note that, since the <C>refine.initialise</C> function is called for all
#!   relevant constraints at the beginning of search, the partition may have
#!   already been split by some earlier constraint by the time that
#!   <C>refine.initialise</C> is called for a later constraint.
#!
#TODO: this is incomplete
#! At most one of the following two functions will generally be implemented.

#! * <C>changed</C> - One or splits occurred.
#! * <C>fixed</C> - One or more points in the partition became fixed
#!
#TODO: this is unclear. Also unimplemented.
#! * <C>rBaseFinished</C> - The rBase has been created (is passed the rbase).
#!   Constraints which care about this can use this to remember the rBase
#!   construction is finished.

DeclareRepresentation("IsBTKitRefiner", IsRefiner, ["name", "check", "refine"]);
BindGlobal("BTKitRefinerType", NewType(BacktrackableStateFamily,
                                       IsBTKitRefiner));
                                       
