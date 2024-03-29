# BacktrackKit, chapter 4
#
# DO NOT EDIT THIS FILE - EDIT EXAMPLES IN THE SOURCE INSTEAD!
#
# This file has been generated by AutoDoc. It contains examples extracted from
# the package documentation. Each example is preceded by a comment which gives
# the name of a GAPDoc XML file and a line range from which the example were
# taken. Note that the XML file in turn may have been generated by AutoDoc
# from some other input.
#
gap> START_TEST("backtrackkit04.tst");

# doc/_Chapter_Constraints.xml:98-105
gap> LoadPackage("BacktrackKit", false);;
gap> Set(RecNames(Constraint));
[ "Centralise", "Centralize", "Conjugate", "Everything", "InCoset", 
  "InGroup", "InLeftCoset", "InRightCoset", "IsEven", "IsOdd", "IsTrivial", 
  "LargestMovedPoint", "MovedPoints", "None", "Normalise", "Normalize", 
  "Nothing", "Stabilise", "Stabilize", "Transport" ]

# doc/_Chapter_Constraints.xml:191-196
gap> con1 := Constraint.InGroup(DihedralGroup(IsPermGroup, 8));
<constraint: in group: Group( [ (1,2,3,4), (2,4) ] )>
gap> con2 := Constraint.InGroup(AlternatingGroup(4));
<constraint: in group: AlternatingGroup( [ 1 .. 4 ] )>

# doc/_Chapter_Constraints.xml:214-219
gap> U := PSL(2,5) * (3,4,6);
RightCoset(Group([ (3,5)(4,6), (1,2,5)(3,4,6) ]),(3,4,6))
gap> Constraint.InCoset(U);
<constraint: in coset: Group( [ (3,5)(4,6), (1,2,5)(3,4,6) ] ) * (3,4,6)

# doc/_Chapter_Constraints.xml:236-239
gap> Constraint.InRightCoset(PSL(2,5), (3,4,6));
<constraint: in coset: Group( [ (3,5)(4,6), (1,2,5)(3,4,6) ] ) * (3,4,6)

# doc/_Chapter_Constraints.xml:256-259
gap> Constraint.InLeftCoset(PSL(2,5), (3,4,6));
<constraint: in coset: Group( [ (3,6)(4,5), (1,2,5)(3,4,6) ] ) * (3,4,6)

# doc/_Chapter_Constraints.xml:286-292
gap> setofsets1 := [[1, 3, 6], [2, 3, 6]];;
gap> setofsets2 := [[1, 2, 5], [1, 5, 7]];;
gap> con := Constraint.Transport(setofsets1, setofsets2, OnSetsSets);
<constraint: transporter of [ [ 1, 3, 6 ], [ 2, 3, 6 ] ] to [ [ 1, 2, 5 ], [ 1\
, 5, 7 ] ] under OnSetsSets>

# doc/_Chapter_Constraints.xml:320-325
gap> con1 := Constraint.Stabilise(CycleDigraph(6), OnDigraphs);
<constraint: stabiliser of CycleDigraph(6) under OnDigraphs>
gap> con2 := Constraint.Stabilise([2,4,6], OnSets);
<constraint: stabiliser of [ 2, 4, 6 ] under OnSets>

# doc/_Chapter_Constraints.xml:344-347
gap> Constraint.Normalise(PSL(2,5));
<constraint: normalise Group( [ (3,5)(4,6), (1,2,5)(3,4,6) ] )>

# doc/_Chapter_Constraints.xml:366-373
gap> D12 := DihedralGroup(IsPermGroup, 12);;
gap> Constraint.Centralise(D12);
<constraint: centralise group Group( [ (1,2,3,4,5,6), (2,6)(3,5) ] )>
gap> x := (1,6)(2,5)(3,4);;
gap> Constraint.Centralise(x);
<constraint: centralise perm (1,6)(2,5)(3,4)>

# doc/_Chapter_Constraints.xml:395-398
gap> Constraint.Conjugate((3,4)(2,5,1), (1,2,3)(4,5));
<constraint: conjugate perm (1,2,5)(3,4) to (1,2,3)(4,5)>

# doc/_Chapter_Constraints.xml:413-418
gap> con1 := Constraint.MovedPoints([1..5]);
<constraint: moved points: [ 1 .. 5 ]>
gap> con2 := Constraint.MovedPoints([2,6,4,5]);
<constraint: moved points: [ 2, 6, 4, 5 ]>

# doc/_Chapter_Constraints.xml:434-437
gap> con := Constraint.LargestMovedPoint(5);
<constraint: largest moved point: 5>

# doc/_Chapter_Constraints.xml:454-459
gap> Constraint.IsEven;
<constraint: is even permutation>
gap> Representative(Constraint.IsEven);
()

# doc/_Chapter_Constraints.xml:476-481
gap> Constraint.IsOdd;
<constraint: is odd permutation>
gap> Representative(Constraint.IsOdd);
(1,2)

# doc/_Chapter_Constraints.xml:495-500
gap> Constraint.IsTrivial;
<trivial constraint: is identity permutation>
gap> Representative(Constraint.IsTrivial);
()

# doc/_Chapter_Constraints.xml:514-519
gap> Constraint.None;
<empty constraint: satisfied by no permutations>
gap> Representative(Constraint.None);
fail

# doc/_Chapter_Constraints.xml:533-538
gap> Constraint.Everything;
<constraint: satisfied by all permutations>
gap> Representative(Constraint.Everything);
()

#
gap> STOP_TEST("backtrackkit04.tst", 1);
