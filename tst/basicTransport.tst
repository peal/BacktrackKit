#@local ps3, ps6, p
gap> START_TEST("basicTransport.tst");
gap> LoadPackage("backtrackkit", false);
true

#
gap> ps3 := PartitionStack(3);
[ [ 1, 2, 3 ] ]
gap> ps6 := PartitionStack(6);
[ [ 1, 2, 3, 4, 5, 6 ] ]
gap> p := BTKit_SimpleSinglePermSearch(ps3,
>           [BTKit_Con.InGroup(3, SymmetricGroup(3))]);;
gap> p in SymmetricGroup(3);
true
gap> p := BTKit_SimpleSinglePermSearch(ps3,
>           [BTKit_Con.InGroup(3, SymmetricGroup(3)),
>            BTKit_Con.SetTransporter(3,[1,2],[2,3])]);;
gap> OnSets([1,2], p) = [2,3];
true
gap> p := BTKit_SimpleSinglePermSearch(ps6,
>           [BTKit_Con.InGroup(6, AlternatingGroup(6)),
>            BTKit_Con.SetTransporter(6,[2,4,6],[1,2,3])]);;
gap> OnSets([2,4,6], p) = [1,2,3];
true
gap> p := BTKit_SimpleSinglePermSearch(ps6,
>           [BTKit_Con.InGroup(6, AlternatingGroup(6)),
>            BTKit_Con.TupleTransporter(6,[2,4,6], [1,2,3]) ]);;
gap> OnTuples([2,4,6], p) = [1,2,3];
true
gap> p := BTKit_SimpleSinglePermSearch(ps6,
>           [BTKit_Con.Nothing()]);
fail
gap> p := BTKit_SimpleSinglePermSearch(ps6,
>           [BTKit_Con.Nothing2()]);
fail

#
gap> STOP_TEST("basicTransport.tst");
