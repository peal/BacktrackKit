gap> ReadPackage("BacktrackKit", "tst/test_functions.g");;
gap> SetInfoLevel(InfoBTKit, 0);
gap> SetInfoLevel(InfoTrace, 0);
gap> BTKit_CentralizerTestSizes := [5..20];;
gap> BTKit_IntersectionTestSizes := [5..15];;
gap> PermCentralizerTests(10);
true
gap> CentralizerTest();
true
gap> IntersectionTests(10);
true
gap> LoadPackage("quickcheck", false);;
gap> lmp := {l...} -> Maximum(1,Maximum(List(l, LargestMovedPoint)));;
gap> QC_CheckEqual([IsPermGroup, IsPermGroup], Intersection, 
> {g,h} -> BTKit_SimpleSearch(PartitionStack(lmp(g,h)), 
>           [BTKit_Con.InGroup(lmp(g,h), g), BTKit_Con.InGroup(lmp(g,h), h)]));;
