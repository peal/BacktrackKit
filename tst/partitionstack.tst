gap> START_TEST("partitionstack.tst");
gap> LoadPackage("datastructures", false);;
gap> t := RecordingTracer();;
gap> p := PartitionStack(6);
[ [ 1, 2, 3, 4, 5, 6 ] ]
gap> PS_AsPartition(p);
[ [ 1, 2, 3, 4, 5, 6 ] ]
gap> PS_Points(p);
6
gap> PS_Cells(p);
1
gap> PS_CellLen(p, 1);
6
gap> s := PS_CellSlice(p, 1);
[ 1, 2, 3, 4, 5, 6 ]
gap> PS_SplitCellByFunction(p, t, 1, {x} -> x mod 2 = 0);;
gap> PS_AsPartition(p);
[ [ 2, 4, 6 ], [ 1, 3, 5 ] ]
gap> IsInternallyConsistent(p);;
gap> PS_SplitCellByFunction(p, t, 1, {x} -> 2);;
gap> PS_AsPartition(p);
[ [ 2, 4, 6 ], [ 1, 3, 5 ] ]
gap> IsInternallyConsistent(p);;
gap> PS_SplitCellByFunction(p, t, 1, {x} -> x);;
gap> PS_AsPartition(p);
[ [ 2 ], [ 1, 3, 5 ], [ 6 ], [ 4 ] ]
gap> IsInternallyConsistent(p);;
gap> PS_SplitCellByFunction(p, t, 2, {x} -> x);;
gap> PS_AsPartition(p);
[ [ 2 ], [ 1 ], [ 6 ], [ 4 ], [ 5 ], [ 3 ] ]
gap> IsInternallyConsistent(p);;
gap> PS_RevertToCellCount(p, 3);
gap> PS_AsPartition(p);
[ [ 2, 4 ], [ 1, 3, 5 ], [ 6 ] ]
gap> IsInternallyConsistent(p);;
gap> PS_RevertToCellCount(p, 2);
gap> PS_AsPartition(p);
[ [ 2, 4, 6 ], [ 1, 3, 5 ] ]
gap> IsInternallyConsistent(p);;
gap> PS_RevertToCellCount(p, 1);
gap> PS_AsPartition(p);
[ [ 1, 2, 3, 4, 5, 6 ] ]
gap> IsInternallyConsistent(p);;
gap> PS_SplitCellByFunction(p, t, 1, {x} -> Int(x/2));;
gap> PS_AsPartition(p);
[ [ 1 ], [ 6 ], [ 4, 5 ], [ 2, 3 ] ]
gap> IsInternallyConsistent(p);;
gap> PS_SplitCellsByFunction(p, t, x -> x);;
gap> PS_AsPartition(p);
[ [ 1 ], [ 6 ], [ 4 ], [ 2 ], [ 5 ], [ 3 ] ]
gap> IsInternallyConsistent(p);;
gap> STOP_TEST("partitionstack.tst");
