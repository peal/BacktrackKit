gap> LoadPackage("BacktrackKit", false);;
gap> ps3 := PartitionStack(3);
[ [ 1, 2, 3 ] ]
gap> ps6 := PartitionStack(6);
[ [ 1, 2, 3, 4, 5, 6 ] ]
gap> G := BTKit_SimpleSearch(ps3, [BTKit_Con.InGroup(3, SymmetricGroup(3))]);;
gap> G = SymmetricGroup(3);
true
gap> G := BTKit_SimpleSearch(ps3, [BTKit_Con.InGroup(3, Group((1,2)(3,4)))]);
Group(())
gap> G := BTKit_SimpleSearch(ps6, [BTKit_Con.InGroup(6, AlternatingGroup(6)),
>                                  BTKit_Con.SetStab(6, [2,4,6]),
>                                  BTKit_Con.TupleStab(6, [1,2])]);;
gap> G = Intersection(AlternatingGroup(6),
>                     Stabilizer(AlternatingGroup(6), [2,4,6], OnSets),
>                     Stabilizer(AlternatingGroup(6), [1,2], OnTuples));
true
gap> graph := Digraph([ [2], [3], [1] ]);;
gap> BTKit_SimpleSearch(ps3, [BTKit_Con.GraphTrans(graph, graph)]) = Group( (1,2,3) );
true

# Trivial intersection of two 'disjoint' C4 x C4 x C4 groups with equal orbits
gap> g1 := Group([(1,2,3,4), (5,6,7,8), (9,10,11,12)]);;
gap> g2 := Group([(1,2,4,3), (5,6,8,7), (9,10,12,11)]);;
gap> Set(BTKit_SimpleSearch(PartitionStack(12),
>                           [BTKit_Con.InGroup(12, g1),
>                            BTKit_Con.InGroup(12, g2)]));
[ () ]
gap> Set(BTKit_SimpleSearch(PartitionStack(12),
>                           [BTKit_Con.InGroupWithOrbitals(12, g1),
>                            BTKit_Con.InGroupWithOrbitals(12, g2)]));
[ () ]

# Trivial intersection of two primitive groups in S_10
gap> LoadPackage("primgrp", false);;
gap> Set(BTKit_SimpleSearch(PartitionStack(10),
>                           [BTKit_Con.InGroup(10, PrimitiveGroup(10, 1)),
>                            BTKit_Con.InGroup(10, PrimitiveGroup(10, 3))]));
[ () ]
