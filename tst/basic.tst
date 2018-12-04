gap> LoadPackage("BacktrackKit", false);;
gap> ps3 := PartitionStack(3);
[ [ 1, 2, 3 ] ]
gap> ps6 := PartitionStack(6);
[ [ 1, 2, 3, 4, 5, 6 ] ]
gap> Set(BTKit_SimpleSearch(ps3, [Con_InGroup(3, SymmetricGroup(3))]));
[ (), (2,3), (1,2), (1,2,3), (1,3,2), (1,3) ]
gap> Set(BTKit_SimpleSearch(ps3, [Con_InGroup(3, Group((1,2)(3,4)))]));
[ () ]
gap> Set(BTKit_SimpleSearch(ps6, [Con_InGroup(6, AlternatingGroup(6)), Con_SetStab(6,[2,4,6]), Con_TupleStab(6,[1,2]) ]));
[ (), (3,5)(4,6) ]
