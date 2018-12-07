gap> LoadPackage("BacktrackKit", false);;
gap> ps3 := PartitionStack(3);
[ [ 1, 2, 3 ] ]
gap> ps6 := PartitionStack(6);
[ [ 1, 2, 3, 4, 5, 6 ] ]
gap> gens := BTKit_SimpleSearch(ps3, [BTKit_Con.InGroup(3, SymmetricGroup(3))]);;
gap> Group(gens) = SymmetricGroup(3);
true
gap> Set(BTKit_SimpleSearch(ps3, [BTKit_Con.InGroup(3, Group((1,2)(3,4)))]));
[ () ]
gap> gens := BTKit_SimpleSearch(ps6, [BTKit_Con.InGroup(6, AlternatingGroup(6)), BTKit_Con.SetStab(6,[2,4,6]), BTKit_Con.TupleStab(6,[1,2]) ]);;
gap> Group(gens) = Intersection(AlternatingGroup(6), Stabilizer(AlternatingGroup(6), [2,4,6], OnSets), Stabilizer(AlternatingGroup(6), [1,2], OnTuples));
true
