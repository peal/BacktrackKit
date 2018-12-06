#! @Chapter Ordered Partition Stack
#!
#! An Ordered Partition Stack is an Ordered Partition which supports
#! splitting a cell, and then later undoing a change, reverting the
#! partition back to an earlier start.


#! @Section API
#!
#! @Description
#! Constructor for partition stacks
#! @Arguments
#! @Returns a partition stack
DeclareGlobalFunction("PartitionStack");

#! @Description
#! Category of partition stacks
DeclareCategory("IsPartitionStack", IsObject);
BindGlobal( "PartitionStackFamily", NewFamily("PartitionStackFamily") );


DeclareRepresentation( "IsPartitionStackRep", IsPartitionStack and IsComponentObjectRep, []);
BindGlobal( "PartitionStackType", NewType(PartitionStackFamily, IsPartitionStackRep));
BindGlobal( "PartitionStackTypeMutable", NewType(PartitionStackFamily,
                                        IsPartitionStackRep and IsMutable));

#! The number of points in the partition
DeclareOperation("PS_Points", [IsPartitionStack]);

#! The number of cells in the partition
DeclareOperation("PS_Cells", [IsPartitionStack]);


#! Return the current partition state as a list of sets
DeclareOperation("PS_AsPartition", [IsPartitionStack]);

#! @Description
#! The size of cell i
#! @Arguments PS, i
DeclareOperation("PS_CellLen", [IsPartitionStack, IsPosInt]);

#! @Description
#! Return an immutable list containing the elements of cell i
#! @Arguments PS, i
DeclareOperation("PS_CellSlice", [IsPartitionStack, IsPosInt]);

#! @Description
#! Return a list of the cells of size 1, in the order they were created
#! @Arguments PS
DeclareOperation("PS_FixedCells", [IsPartitionStack]);

#! @Description
#! Return a list of points in cells of size 1, in the order they were created
#! @Arguments PS
DeclareOperation("PS_FixedPoints", [IsPartitionStack]);

#! @Description
#! Return the cell which contains value i
#! @Arguments PS, i
DeclareOperation("PS_CellOfPoint", [IsPartitionStack, IsPosInt]);

#! @Description
#! Revert the state of the partition stack to when there were i cells.
#! This requires that i is less than PS_Cells(PS)
#! @Arguments PS, i
DeclareOperation("PS_RevertToCellCount", [IsPartitionStack, IsPosInt]);

#! @Description
#! Split cell i of a partition stack. The values in the cell are split
#! so that values in the cell with different images under f are put into
#! different cells.
#!
#! @Arguments PS, i, f
DeclareOperation("PS_SplitCellByFunction", [IsPartitionStack, IsTracer, IsPosInt, IsFunction]);

#! @Description
#! Apply SplitCellByFunction to every cell in PS
#!
#! @Arguments PS, f
DeclareOperation("PS_SplitCellsByUnorderedFunction", [IsPartitionStack, IsTracer, IsFunction]);

#! @Description
#! Split cell i of a partition stack. The values in the cell are split
#! so that values in the cell with different images under f are put into
#! different cells.
#!
#! @Arguments PS, i, f
DeclareOperation("PS_SplitCellByUnorderedFunction", [IsPartitionStack, IsTracer, IsPosInt, IsFunction]);

#! @Description
#! Apply SplitCellByFunction to every cell in PS
#!
#! @Arguments PS, f
DeclareOperation("PS_SplitCellsByFunction", [IsPartitionStack, IsTracer, IsFunction]);

DeclareOperation("PS_UNSAFE_CellSlice", [IsPartitionStack, IsPosInt]);

DeclareOperation("PS_UNSAFE_FixupCell", [IsPartitionStack, IsPosInt]);

DeclareInfoClass("InfoPartitionStack");

SetInfoLevel(InfoPartitionStack, 1);
