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

################################################################################
## Chunks

#! @BeginChunk maybeinfinite
#! Note that the set of such permutations may be infinite.
#! @EndChunk

#! @BeginChunk isinfinite
#! Note that the set of such permutations is infinite.
#! @EndChunk

## End chunks
################################################################################


#! @Chapter Constraints

#! @Section The concept of constraints in &BacktrackKit;
#! @SectionLabel concept

#! At its core, &BacktrackKit; searches for permutations that satisfy a collection
#! of constraints.
#! A **constraint** is a property such that for any given permutation,
#! it is easy to check whether that permutation has the property or not.
#! In addition, if the set of permutations that satisfy a property is nonempty,
#! then that set must be a (possibly infinite) permutation group,
#! or a coset thereof.
#!
#! For example:
#! * “is even”,
#! * “commutes with the permutation $x$”,
#! * “conjugates the group $G = \langle X \rangle$ to the group
#!   $H = \langle Y \rangle$”,
#! * “is an automorphism of the graph $\Gamma$”, and
#! * “is a member of the group $G = \langle X \rangle$”
#! 
#! are all examples of constraints.
#! On the other hand:
#! * “is a member of the socle of the group $G$”, and
#! * “is a member of a largest maximal subgroup of the group $G$”
#!
#! do not qualify, unless generating sets for the socle and the largest
#! maximal subgroups of $G$ are **already** known,  and there is a unique such
#! maximal subgroup
#! (in which case these properties become instances of the constraint
#! “is a member of the group defined by the generating set...”).
#!
#! The term ‘constraint’ comes from the computer science field of constraint
#! satisfaction problems, constraint programming, and constraint solvers,
#! with which backtrack search algorithms are very closely linked.
#!
#! To use &BacktrackKit; via its native interface,
#! it is necessary to choose a selection of constraints that, in conjunction,
#! define the permutation(s) that you wish to find.
#! &BacktrackKit; provides a number of built-in constraints. These can be created with
#! the functions contained in the <Ref Var="Constraint"/> record,
#! which are documented individually in
#! Section&nbsp;<Ref Sect="Section_providedcons"/>.
#! While the included constraints are not exhaustive,
#! they do cover a wide range of problems in computational group theory,
#! and we welcome suggestions of additional constraints that we could implement.
#!
#! Internally, a constraint is eventually converted into one or more refiners
#! by that the time that the search takes place. Refiners are introduced in
#! Chapter&nbsp;<Ref Chap="Chapter_Refiners"/>, and can be given in place
#! of constraints.
#! We do not explicitly document the conversion of &BacktrackKit;
#! constraints into refiners;
#! the conversion may change in future versions of &BacktrackKit;
#! as we introduce improve our refiners and introduce new ones.
#! In addition, we do not explicitly document the kind of object that a
#! &BacktrackKit; constraint is. Currently, constraints may be
#! &BacktrackKit; refiners,
#! <Package>GraphBacktracking</Package> refiners,
#! &BacktrackKit; refiners,
#! records, lists, or the value <K>fail</K>.


#! @Section The <C>Constraints</C> record
#! @SectionLabel ConstraintsRec

#! @Description
#!
#! <Ref Var="Constraint"/> is a record that contains functions for producing
#! all of the constraints that &BacktrackKit; provides.
#!
#! The members of <Ref Var="Constraint"/> are documented individually in
#! Section&nbsp;<Ref Sect="Section_providedcons"/>.
#!
#! The members whose names differ only by their “-ise” and “-ize” endings
#! are synonyms, included to accommodate different spellings in English.
#! @BeginExampleSession
#! gap> LoadPackage("vole", false);;
#! gap> Set(RecNames(Constraint));
#! [ "Centralise", "Centralize", "Conjugate", "InCoset", "InGroup", 
#!   "InLeftCoset", "InRightCoset", "IsEven", "IsOdd", "LargestMovedPoint", 
#!   "MovedPoints", "None", "Normalise", "Normalize", "Stabilise", "Stabilize", 
#!   "Transport" ]
#!  @EndExampleSession
DeclareGlobalVariable("Constraint");
# TODO When we require GAP >= 4.12, use GlobalName rather than GlobalVariable
InstallValue(Constraint, AtomicRecord(rec()));


################################################################################

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




#! @Section Constraints via the <C>Constraint</C> record
#! @SectionLabel providedcons

#! In this section, we individually document the functions of the
#! <Ref Var="Constraint"/> record, which can be used to create the
#! built-in constraints provided by &BacktrackKit;
#!
#! Many of these constraints come in pairs, with a “group” version,
#! and a corresponding “coset” version.
#! These relationships are given in the following table.

#! <Table Align="ll">
#! <Row>
#!   <Item>Group version</Item>
#!   <Item>Coset version</Item>
#! </Row>
#! <HorLine/>
#! <Row>
#!   <Item><Ref Func="Constraint.InGroup"/></Item>
#!   <Item>
#!     <Ref Func="Constraint.InCoset"/>
#!     <P/>
#!     <Ref Func="Constraint.InRightCoset"/>
#!     <P/>
#!     <Ref Func="Constraint.InLeftCoset"/>
#!   </Item>
#! </Row>
#! <Row>
#!   <Item>
#!     <Ref Func="Constraint.Stabilise"/>
#!   </Item>
#!   <Item><Ref Func="Constraint.Transport"/></Item>
#! </Row>
#! <Row>
#!   <Item>
#!     <Ref Func="Constraint.Normalise"/>
#!   </Item>
#!   <Item>
#!     <Ref Func="Constraint.Conjugate"/>
#!   </Item>
#! </Row>
#! <Row>
#!   <Item>
#!     <Ref Func="Constraint.Centralise"/>
#!   </Item>
#!   <Item>
#!     <Ref Func="Constraint.Conjugate"/>
#!   </Item>
#! </Row>
#! <Row>
#!   <Item><Ref Func="Constraint.MovedPoints"/></Item>
#!   <Item>N/A</Item>
#! </Row>
#! <Row>
#!   <Item><Ref Func="Constraint.LargestMovedPoint"/></Item>
#!   <Item>N/A</Item>
#! </Row>
#! <Row>
#!   <Item><Ref Var="Constraint.IsEven"/></Item>
#!   <Item><Ref Var="Constraint.IsOdd"/></Item>
#! </Row>
#! <Row>
#!   <Item>N/A</Item>
#!   <Item><Ref Var="Constraint.None"/></Item>
#! </Row>
#! </Table>



#! @Arguments G
#! @Returns A constraint
#! @Description
#! This constraint is satisfied by precisely those permutations in the
#! permutation group <A>G</A>.
#! @BeginExampleSession
#! gap> con1 := Constraint.InGroup(DihedralGroup(IsPermGroup, 8));;
#! gap> con2 := Constraint.InGroup(AlternatingGroup(4));;
#! gap> VoleFind.Group(con1, con2) = Group([(1,3)(2,4), (1,4)(2,3)]);
#! true
#! @EndExampleSession
DeclareGlobalFunction("Constraint.InGroup");

#! @Arguments U
#! @Returns A constraint
#! @Description
#! This constraint is satisfied by precisely those permutations in the &GAP;
#! right coset object <A>U</A>.
#!
#! See also <Ref Func="Constraint.InLeftCoset"/>
#! and <Ref Func="Constraint.InRightCoset"/>, which allow a coset to be specifed
#! by a subgroup and a representative element.
#! @BeginExampleSession
#! gap> U := PSL(2,5) * (3,4,6);
#! RightCoset(Group([ (3,5)(4,6), (1,2,5)(3,4,6) ]),(3,4,6))
#! gap> x := VoleFind.Coset(Constraint.InCoset(U), AlternatingGroup(6));
#! RightCoset(Group([ (3,5)(4,6), (2,4)(5,6), (1,2,6,5,4) ]),(1,5)(2,3,4,6))
#! gap> x = Intersection(U, AlternatingGroup(6));
#! true
#! @EndExampleSession
DeclareGlobalFunction("Constraint.InCoset");

#! @Arguments G, x
#! @Returns A constraint
#! @Description
#! This constraint is satisfied by precisely those permutations in the right
#! coset of the group <A>G</A> determined by the permutation <A>x</A>.
#!
#! See also <Ref Func="Constraint.InLeftCoset"/> for the left-hand version,
#! and <Ref Func="Constraint.InCoset"/> for a &GAP; right coset object.
#! @BeginExampleSession
#! gap> x := VoleFind.Coset(Constraint.InRightCoset(PSL(2,5), (3,4,6)),
#! >                        Constraint.InGroup(AlternatingGroup(6)));
#! RightCoset(Group([ (3,5)(4,6), (2,4)(5,6), (1,2,6,5,4) ]),(1,5)(2,3,4,6))
#! gap> x = Intersection(PSL(2,5) * (3,4,6), AlternatingGroup(6));
#! true
#! @EndExampleSession
DeclareGlobalFunction("Constraint.InRightCoset");

#! @Arguments G, x
#! @Returns A constraint
#! @Description
#! This constraint is satisfied by precisely those permutations in the left
#! coset of the group <A>G</A> determined by the permutation <A>x</A>.
#! 
#! See also <Ref Func="Constraint.InRightCoset"/> for the right-hand version,
#! and <Ref Func="Constraint.InCoset"/> for a &GAP; right coset object.
#! @BeginExampleSession
#! gap> x := VoleFind.Rep(Constraint.InLeftCoset(PSL(2,5), (3,4,6)),
#! >                      Constraint.InGroup(AlternatingGroup(6)));
#! (1,6,2,3,4)
#! gap> SignPerm(x) = 1 and ForAny(PSL(2,5), g -> x = (3,4,6) * g);
#! true
#! @EndExampleSession
DeclareGlobalFunction("Constraint.InLeftCoset");


#! @Arguments object1, object2[, action]
#! @Returns A constraint
#! @Description
#! This constraint is satisfied by precisely those permutations that map
#! <A>object1</A> to <A>object2</A> under the given group <A>action</A>,
#! i.e. all permutations `g` such that
#! `<A>action</A>(<A>object1</A>,g)=<A>object2</A>`.
#! @InsertChunk maybeinfinite
#!
#! The combinations of objects and actions that are supported by
#! `Constraint.Transport` are given in the table below.
#!
#! @InsertChunk DefaultAction
#!
#! @InsertChunk ActionsTable
#! @BeginExampleSession
#! gap> setofsets1 := [[1, 3, 6], [2, 3, 6], [2, 4, 7], [4, 5, 7]];;
#! gap> setofsets2 := [[1, 2, 5], [1, 5, 7], [3, 4, 6], [4, 6, 7]];;
#! gap> con := Constraint.Transport(setofsets1, setofsets2, OnSetsSets);;
#! gap> VoleFind.Rep(con);
#! (1,2,7,6)(3,5)
#! gap> VoleFind.Rep(con, AlternatingGroup(7) * (1,2));
#! (1,2,7,6,5,3)
#! gap> VoleFind.Rep(con, DihedralGroup(IsPermGroup, 14));
#! fail
#! @EndExampleSession
DeclareGlobalFunction("Constraint.Transport");


#! @BeginGroup StabiliseDoc
#! @Arguments object[, action]
#! @Returns A constraint
#! @Description
#! This constraint is satisfied by precisely those permutations that fix
#! <A>object</A> under the given group <A>action</A>,
#! i.e. all permutations `g` such that
#! `<A>action</A>(<A>object</A>,g)=<A>object</A>`.
#! @InsertChunk maybeinfinite
#!
#! The combinations of objects and actions that are supported by
#! `Constraint.Stabilise` are given in the table below.
#!
#! @InsertChunk DefaultAction
#!
#! @InsertChunk ActionsTable
DeclareGlobalFunction("Constraint.Stabilise");
#! @EndGroup
#! @Arguments object[, action]
#! @Group StabiliseDoc
#! @BeginExampleSession
#! gap> con1 := Constraint.Stabilise(CycleDigraph(6), OnDigraphs);;
#! gap> con2 := Constraint.Stabilise([2,4,6], OnSets);;
#! gap> VoleFind.Group(con1, 6);
#! Group([ (1,2,3,4,5,6) ])
#! gap> VoleFind.Group(con2, 6);
#! Group([ (4,6), (2,4,6), (3,5)(4,6), (1,3,5)(2,4,6) ])
#! gap> VoleFind.Group(con1, con2, 6);
#! Group([ (1,3,5)(2,4,6) ])
#! @EndExampleSession
DeclareGlobalFunction("Constraint.Stabilize");

#! @BeginGroup NormaliseDoc
#! @Arguments G
#! @Returns A constraint
#! @Description
#! This constraint is satisfied by precisely those permutations that
#! normalise the permutation group <A>G</A>,
#! i.e. that preserve <A>G</A> under conjugation.
#!
#! @InsertChunk isinfinite
DeclareGlobalFunction("Constraint.Normalise");
#! @EndGroup
#! @Arguments G
#! @Group NormaliseDoc
#! @BeginExampleSession
#! gap> con := Constraint.Normalise(PSL(2,5));;
#! gap> N := VoleFind.Group(con, SymmetricGroup(6));
#! Group([ (3,4,5,6), (2,3,5,6), (1,2,4,3,6) ])
#! gap> (3,4,5,6) in N and not (3,4,5,6) in PSL(2,5);
#! true
#! gap> Index(N, PSL(2,5));
#! 2
#! gap> PSL(2,5) = VoleFind.Group(con, AlternatingGroup(6));
#! true
#! @EndExampleSession
DeclareGlobalFunction("Constraint.Normalize");


#! @BeginGroup CentraliseDoc
#! @Arguments G
#! @Returns A constraint
#! @Description
#! This constraint is satisfied by precisely those permutations that
#! commute with <A>G</A>, if <A>G</A> is a permutation, or that
#! commute with every element of <A>G</A>, if <A>G</A> is a permutation group.
#!
#! @InsertChunk isinfinite
DeclareGlobalFunction("Constraint.Centralise");
#! @EndGroup
#! @Arguments G
#! @Group CentraliseDoc
#! @BeginExampleSession
#! gap> D12 := DihedralGroup(IsPermGroup, 12);;
#! gap> VoleFind.Group(6, Constraint.Centralise(D12));
#! Group([ (1,4)(2,5)(3,6) ])
#! gap> x := (1,6)(2,5)(3,4);;
#! gap> G := VoleFind.Group(AlternatingGroup(6), Constraint.Centralise(x));
#! Group([ (2,3)(4,5), (2,4)(3,5), (1,2,3)(4,6,5) ])
#! gap> ForAll(G, g -> SignPerm(g) = 1 and g * x = x * g);
#! true
#! @EndExampleSession
DeclareGlobalFunction("Constraint.Centralize");


#! @Arguments x, y
#! @Returns A constraint
#! @Description
#! This constraint is satisfied by precisely those permutations that
#! conjugate <A>x</A> to <A>y</A>, where <A>x</A> and <A>y</A> are either
#! both permutations, or both permutation groups.
#!
#! @InsertChunk maybeinfinite
#!
#! This constraint is equivalent to
#! `Constraint.Transport(<A>x</A>,<A>y</A>,OnPoints)`.
#!
#! @BeginExampleSession
#! gap> con := Constraint.Conjugate((3,4)(2,5,1), (1,2,3)(4,5));
#! <constraint: conjugate perm (1,2,5)(3,4) to (1,2,3)(4,5)>
#! gap> VoleFind.Rep(con);
#! (1,2,3,5)
#! gap> VoleFind.Rep(con, PSL(2,5));
#! (1,3,4,5,2)
#! @EndExampleSession
DeclareGlobalFunction("Constraint.Conjugate");


#! @Arguments pointlist
#! @Returns A constraint
#! @Description
#! This constraint is a shorthand for
#! `Constraint.InGroup(SymmetricGroup(<A>pointlist</A>))`.
#! See <Ref Func="Constraint.InGroup"/>.
#! @BeginExampleSession
#! gap> con1 := Constraint.MovedPoints([1..5]);
#! <constraint: moved points: [ 1 .. 5 ]>
#! gap> con2 := Constraint.MovedPoints([2,6,4,5]);
#! <constraint: moved points: [ 2, 6, 4, 5 ]>
#! gap> VoleFind.Group(con1, con2) = SymmetricGroup([2,4,5]);
#! true
#! @EndExampleSession
DeclareGlobalFunction("Constraint.MovedPoints");

#! @Arguments point
#! @Returns A constraint
#! @Description
#! This constraint is a shorthand for
#! `Constraint.InGroup(SymmetricGroup(<A>point</A>))`,
#! where <A>point</A> is a nonnegative integer.
#! See <Ref Func="Constraint.InGroup"/>.
#! @BeginExampleSession
#! gap> con := Constraint.LargestMovedPoint(5);
#! <constraint: largest moved point: 5>
#! gap> VoleFind.Group(con) = SymmetricGroup(5);
#! true
#! @EndExampleSession
DeclareGlobalFunction("Constraint.LargestMovedPoint");


#! @Description
#! This constraint is satisfied by the even permutations,
#! i.e. those permutations with sign `1`.
#! In other words, this constraint restricts a search to some alternating
#! group.
#!
#! @InsertChunk isinfinite
#! @BeginExampleSession
#! gap> Constraint.IsEven;
#! <constraint: is even permutation>
#! gap> Representative(Constraint.IsEven);
#! ()
#! @EndExampleSession
DeclareGlobalVariable("Constraint.IsEven");

#! @Description
#! This constraint is satisfied by the odd permutations,
#! i.e. those permutations with sign `-1`.
#! In other words, this constraint restricts a search to the unique coset of
#! some alternating group.
#!
#! @InsertChunk isinfinite
#! @BeginExampleSession
#! gap> Constraint.IsOdd;
#! <constraint: is odd permutation>
#! gap> Representative(Constraint.IsOdd);
#! (1,2)
#! @EndExampleSession
DeclareGlobalVariable("Constraint.IsOdd");

#! @Description
#! This constraint is satisfied by the identity permutation and no others.
#! @BeginExampleSession
#! gap> Constraint.IsTrivial;
#! <empty constraint: satisfied by no permutations>
#! gap> con := Constraint.IsTrivial;
#! <trivial constraint: is identity permutation>
#! gap> Representative(con);
#! ()
#! @EndExampleSession
DeclareGlobalVariable("Constraint.IsTrivial");

#! @Description
#! This constraint is satisfied by no permutations.
#!
#! This constraint will typically not be required by the user.
#! @BeginExampleSession
#! gap> Constraint.None;
#! <empty constraint: satisfied by no permutations>
#! gap> Representative(Constraint.None);
#! fail
#! @EndExampleSession
DeclareGlobalVariable("Constraint.None");
