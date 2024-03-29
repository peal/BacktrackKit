#@local ps3, ps6, G, p, graph, g1, g2
gap> START_TEST("basic.tst");
gap> LoadPackage("backtrackkit", false);
true

#
gap> ps3 := PartitionStack(3);
[ [ 1, 2, 3 ] ]
gap> ps6 := PartitionStack(6);
[ [ 1, 2, 3, 4, 5, 6 ] ]
gap> G := BTKit_SimpleSearch(ps3, [BTKit_Refiner.InGroup(SymmetricGroup(3))]);;
gap> G = SymmetricGroup(3);
true
gap> G := BTKit_SimpleSearch(ps3, [BTKit_Refiner.InGroup(Group((1,2)(3,4)))]);
Error, Refiner InCoset-BTKit requires 4 points, but the partition only has 3
gap> G := BTKit_SimpleSearch(ps6, [BTKit_Refiner.InGroup(AlternatingGroup(6)),
>                                  BTKit_Refiner.SetStab([2,4,6]),
>                                  BTKit_Refiner.TupleStab([1,2])]);;
gap> G = Intersection(AlternatingGroup(6),
>                     Stabilizer(AlternatingGroup(6), [2,4,6], OnSets),
>                     Stabilizer(AlternatingGroup(6), [1,2], OnTuples));
true
gap> G := BTKit_SimpleSearch(ps6, [BTKit_Refiner.IdentityForTesting(1)]);;
gap> G = Group([()]);
true
gap> G := BTKit_SimpleSearch(ps6, [BTKit_Refiner.IsEven()]);;
gap> G = AlternatingGroup(6);
true
gap> p := BTKit_SimpleSinglePermSearch(ps6, [BTKit_Refiner.IsOdd()]);;
gap> SignPerm(p);
-1
gap> BTKit_SimpleSinglePermSearch(ps6, [BTKit_Refiner.IsEven(), BTKit_Refiner.IsOdd()]);
fail

#
gap> graph := Digraph([ [2], [3], [1] ]);;
gap> BTKit_SimpleSearch(ps3, [BTKit_Refiner.GraphTrans(graph, graph)]) = Group( (1,2,3) );
true

# Trivial intersection of two 'disjoint' C4 x C4 x C4 groups with equal orbits
gap> g1 := Group([(1,2,3,4), (5,6,7,8), (9,10,11,12)]);;
gap> g2 := Group([(1,2,4,3), (5,6,8,7), (9,10,12,11)]);;
gap> Set(BTKit_SimpleSearch(PartitionStack(12),
>                           [BTKit_Refiner.InGroup(g1),
>                            BTKit_Refiner.InGroup(g2)]));
[ () ]
gap> Set(BTKit_SimpleSearch(PartitionStack(12),
>                           [BTKit_Refiner.InGroupWithOrbitals(g1),
>                            BTKit_Refiner.InGroupWithOrbitals(g2)]));
[ () ]

# Trivial intersection of two primitive groups in S_10
gap> Set(BTKit_SimpleSearch(PartitionStack(10),
>                           [BTKit_Refiner.InGroup(PrimitiveGroup(10, 1)),
>                            BTKit_Refiner.InGroup(PrimitiveGroup(10, 3))]));
[ () ]

#
gap> STOP_TEST("basic.tst");
