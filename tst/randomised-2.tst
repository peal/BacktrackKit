gap> LoadPackage("BacktrackKit", false);
true
gap> ReadPackage("BacktrackKit", "tst/test_functions.g");;
gap> LoadPackage("quickcheck", false);;
gap> lmp := {l...} -> Maximum(1,Maximum(List(l, LargestMovedPoint)));;
gap> QC_CheckEqual([IsPermGroup, IsPermGroup], Intersection, 
> {g,h} -> BTKit_SimpleSearch(PartitionStack(lmp(g,h)), 
>           [BTKit_Con.InGroup(g), BTKit_Con.InGroup(h)]));;
