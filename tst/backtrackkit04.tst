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

# doc/_Chapter_Constraints.xml:108-115
gap> LoadPackage("vole", false);;
gap> Set(RecNames(Constraint));
[ "Centralise", "Centralize", "Conjugate", "InCoset", "InGroup", 
  "InLeftCoset", "InRightCoset", "IsEven", "IsOdd", "LargestMovedPoint", 
  "MovedPoints", "None", "Normalise", "Normalize", "Stabilise", "Stabilize", 
  "Transport" ]

# doc/_Chapter_Constraints.xml:197-202
gap> con1 := Constraint.InGroup(DihedralGroup(IsPermGroup, 8));;
gap> con2 := Constraint.InGroup(AlternatingGroup(4));;
gap> VoleFind.Group(con1, con2) = Group([(1,3)(2,4), (1,4)(2,3)]);
true

# doc/_Chapter_Constraints.xml:220-227
gap> U := PSL(2,5) * (3,4,6);
RightCoset(Group([ (3,5)(4,6), (1,2,5)(3,4,6) ]),(3,4,6))
gap> x := VoleFind.Coset(Constraint.InCoset(U), AlternatingGroup(6));
RightCoset(Group([ (3,5)(4,6), (2,4)(5,6), (1,2,6,5,4) ]),(1,5)(2,3,4,6))
gap> x = Intersection(U, AlternatingGroup(6));
true

# doc/_Chapter_Constraints.xml:244-250
gap> x := VoleFind.Coset(Constraint.InRightCoset(PSL(2,5), (3,4,6)),
>                        Constraint.InGroup(AlternatingGroup(6)));
RightCoset(Group([ (3,5)(4,6), (2,4)(5,6), (1,2,6,5,4) ]),(1,5)(2,3,4,6))
gap> x = Intersection(PSL(2,5) * (3,4,6), AlternatingGroup(6));
true

# doc/_Chapter_Constraints.xml:267-273
gap> x := VoleFind.Rep(Constraint.InLeftCoset(PSL(2,5), (3,4,6)),
>                      Constraint.InGroup(AlternatingGroup(6)));
(1,6,2,3,4)
gap> SignPerm(x) = 1 and ForAny(PSL(2,5), g -> x = (3,4,6) * g);
true

# doc/_Chapter_Constraints.xml:300-310
gap> setofsets1 := [[1, 3, 6], [2, 3, 6], [2, 4, 7], [4, 5, 7]];;
gap> setofsets2 := [[1, 2, 5], [1, 5, 7], [3, 4, 6], [4, 6, 7]];;
gap> con := Constraint.Transport(setofsets1, setofsets2, OnSetsSets);;
gap> VoleFind.Rep(con);
(1,2,7,6)(3,5)
gap> VoleFind.Rep(con, AlternatingGroup(7) * (1,2));
(1,2,7,6,5,3)
gap> VoleFind.Rep(con, DihedralGroup(IsPermGroup, 14));
fail

# doc/_Chapter_Constraints.xml:338-347
gap> con1 := Constraint.Stabilise(CycleDigraph(6), OnDigraphs);;
gap> con2 := Constraint.Stabilise([2,4,6], OnSets);;
gap> VoleFind.Group(con1, 6);
Group([ (1,2,3,4,5,6) ])
gap> VoleFind.Group(con2, 6);
Group([ (4,6), (2,4,6), (3,5)(4,6), (1,3,5)(2,4,6) ])
gap> VoleFind.Group(con1, con2, 6);
Group([ (1,3,5)(2,4,6) ])

# doc/_Chapter_Constraints.xml:366-376
gap> con := Constraint.Normalise(PSL(2,5));;
gap> N := VoleFind.Group(con, SymmetricGroup(6));
Group([ (3,4,5,6), (2,3,5,6), (1,2,4,3,6) ])
gap> (3,4,5,6) in N and not (3,4,5,6) in PSL(2,5);
true
gap> Index(N, PSL(2,5));
2
gap> PSL(2,5) = VoleFind.Group(con, AlternatingGroup(6));
true

# doc/_Chapter_Constraints.xml:395-404
gap> D12 := DihedralGroup(IsPermGroup, 12);;
gap> VoleFind.Group(6, Constraint.Centralise(D12));
Group([ (1,4)(2,5)(3,6) ])
gap> x := (1,6)(2,5)(3,4);;
gap> G := VoleFind.Group(AlternatingGroup(6), Constraint.Centralise(x));
Group([ (2,3)(4,5), (2,4)(3,5), (1,2,3)(4,6,5) ])
gap> ForAll(G, g -> SignPerm(g) = 1 and g * x = x * g);
true

# doc/_Chapter_Constraints.xml:426-433
gap> con := Constraint.Conjugate((3,4)(2,5,1), (1,2,3)(4,5));
<constraint: conjugate perm (1,2,5)(3,4) to (1,2,3)(4,5)>
gap> VoleFind.Rep(con);
(1,2,3,5)
gap> VoleFind.Rep(con, PSL(2,5));
(1,3,4,5,2)

# doc/_Chapter_Constraints.xml:448-455
gap> con1 := Constraint.MovedPoints([1..5]);
<constraint: moved points: [ 1 .. 5 ]>
gap> con2 := Constraint.MovedPoints([2,6,4,5]);
<constraint: moved points: [ 2, 6, 4, 5 ]>
gap> VoleFind.Group(con1, con2) = SymmetricGroup([2,4,5]);
true

# doc/_Chapter_Constraints.xml:471-476
gap> con := Constraint.LargestMovedPoint(5);
<constraint: largest moved point: 5>
gap> VoleFind.Group(con) = SymmetricGroup(5);
true

# doc/_Chapter_Constraints.xml:493-498
gap> Constraint.IsEven;
<constraint: is even permutation>
gap> Representative(Constraint.IsEven);
()

# doc/_Chapter_Constraints.xml:515-520
gap> Constraint.IsOdd;
<constraint: is odd permutation>
gap> Representative(Constraint.IsOdd);
(1,2)

# doc/_Chapter_Constraints.xml:531-538
gap> Constraint.IsTrivial;
<empty constraint: satisfied by no permutations>
gap> con := Constraint.IsTrivial;
<trivial constraint: is identity permutation>
gap> Representative(con);
()

# doc/_Chapter_Constraints.xml:551-556
gap> Constraint.None;
<empty constraint: satisfied by no permutations>
gap> Representative(Constraint.None);
fail

#
gap> STOP_TEST("backtrackkit04.tst", 1);
