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
gap> G := BTKit_SimpleSearch(ps6, [BTKit_Con.InGroup(6, AlternatingGroup(6)), BTKit_Con.SetStab(6,[2,4,6]), BTKit_Con.TupleStab(6,[1,2]) ]);;
gap> G = Intersection(AlternatingGroup(6), Stabilizer(AlternatingGroup(6), [2,4,6], OnSets), Stabilizer(AlternatingGroup(6), [1,2], OnTuples));
true
gap> graph := [ [ [1,2] ], [ [1,3] ], [ [1,1] ] ];;
gap> BTKit_SimpleSearch(ps3, [BTKit_Con.GraphTrans( graph, graph)]) = Group( (1,2,3) );
true
