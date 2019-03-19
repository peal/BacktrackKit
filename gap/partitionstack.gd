#
# BacktrackKit: An extensible, easy to understand backtracking framework
#
#! @Chapter Ordered partition stack
#!
#! An <E>ordered partition stack</E> is an ordered partition which supports
#! splitting a cell, and then later undoing a change, reverting the
#! partition back to an earlier state.


#! @Section API
#!
#! @Description
#! Constructor for partition stacks.
#!
#! @Arguments
#! @Returns a partition stack.
DeclareGlobalFunction("PartitionStack");

#! @Description
#! Category of partition stacks.
DeclareCategory("IsPartitionStack", IsObject);
BindGlobal( "PartitionStackFamily", NewFamily("PartitionStackFamily") );


DeclareRepresentation( "IsPartitionStackRep",
                       IsPartitionStack and IsComponentObjectRep, []);
BindGlobal( "PartitionStackType",
            NewType(PartitionStackFamily, IsPartitionStackRep));
BindGlobal( "PartitionStackTypeMutable",
            NewType(PartitionStackFamily, IsPartitionStackRep and IsMutable));

#! @Description
#! Return the number of points on which the partition stack <A>PS</A> is
#! defined.
#!
#! @Arguments PS
#! @Returns a positive integer.
DeclareOperation("PS_Points", [IsPartitionStack]);

#! @Description
#! The number of cells in the current partition state of the partition stack
#! <A>PS</A>.
#!
#! @Arguments PS
#! @Returns a positive integer.
DeclareOperation("PS_Cells", [IsPartitionStack]);

#! @Description
#! Return <K>true</K> if all the cells of the current partition state of the
#! partition stack <A>PS</A> have size 1.
#!
#! @Arguments PS
#! @Returns <K>true</K> or <K>false</K>.
DeclareOperation("PS_Fixed", [IsPartitionStack]);

#! @Description
#! Return the current partition state of the partition stack <A>PS</A> as a
#! list of sets, in the correct order.
#!
#! @Arguments PS
#! @Returns a list of lists of positive integers.
DeclareOperation("PS_AsPartition", [IsPartitionStack]);

#! @Description
#! The size of cell <A>i</A> in the current partition state of the partition
#! stack <A>PS</A>.
#! This requires that <A>i</A> is contained in <C>[1..PS_Cells(<A>PS</A>)]</C>.
#!
#! @Arguments PS, i
#! @Returns a positive integer.
DeclareOperation("PS_CellLen", [IsPartitionStack, IsPosInt]);

#! @Description
#! Return an immutable list containing the elements of cell <A>i</A> in
#! the current partition state of the partition stack <A>PS</A>.
#! This requires that <A>i</A> is contained in <C>[1..PS_Cells(<A>PS</A>)]</C>.
#!
#! @Arguments PS, i
#! @Returns an immutable list of positive integers.
DeclareOperation("PS_CellSlice", [IsPartitionStack, IsPosInt]);

#! @Description
#! Return a list of the 1-element cells of the current state of the partition
#! stack <A>PS</A>, in the order in which the cells came to have size 1.
#!
#! @Arguments PS
#! @Returns a list of 1-element lists of positive integers.
DeclareOperation("PS_FixedCells", [IsPartitionStack]);

#! @Description
#! Return a list of points in 1-element cells of the partition stack <A>PS</A>,
#! in the order in which the cells came to have size 1. In other words, return
#! <C>Concatenation(PS_FixedCells(<A>PS</A>))</C>.
#!
#! @Arguments PS
#! @Returns a list of positive integers.
DeclareOperation("PS_FixedPoints", [IsPartitionStack]);

#! @Description
#! Return the index of the cell containing the value <A>i</A> in the current
#! partition state of the partition stack <A>PS</A>.
#! This requires that <A>i</A> is contained in <C>[1..PS_Points(<A>PS</A>)]</C>.
#!
#! @Arguments PS, i
#! @Returns a positive integer.
DeclareOperation("PS_CellOfPoint", [IsPartitionStack, IsPosInt]);

#! @Description
#! Revert the state of the partition stack <A>PS</A> to when there were
#! <A>i</A> cells.
#! This requires that <A>i</A> is contained in <C>[1..PS_Cells(<A>PS</A>)]</C>.
#!
#! @Arguments PS, i
#! @Returns nothing.
DeclareOperation("PS_RevertToCellCount", [IsPartitionStack, IsPosInt]);

#TODO: what is the different between ByFunction and ByUnorderedFunction?
#! @Description
#! Split cell <A>i</A> of the current partition state of the partition stack
#! <A>PS</A> according to the function <A>f</A>. The values in the cell are
#! split so that those with different images under <A>f</A> are put into
#! different cells.
#! The second argument <A>t</A> should be a tracer.
#!
#! @Arguments PS, t, i, f
#! @Returns <K>true</K> or <K>false</K>.
DeclareOperation("PS_SplitCellByFunction",
                 [IsPartitionStack, IsTracer, IsPosInt, IsFunction]);

#! @Description
#! Apply <C>PS_SplitCellByFunction</C> to every active cell in the partition
#! stack <A>PS</A>.
#!
#! @Arguments PS, t, f
#! @Returns <K>true</K> or <K>false</K>.
DeclareOperation("PS_SplitCellsByFunction",
                 [IsPartitionStack, IsTracer, IsFunction]);

#! @Description
#! Split cell <A>i</A> of the current partition state of the partition stack
#! <A>PS</A> according to the function <A>f</A>. The values in the cell are
#! split so that those with different images under <A>f</A> are put into
#! different cells.
#! The second argument <A>t</A> should be a tracer.
#!
#! @Arguments PS, t, i, f
DeclareOperation("PS_SplitCellByUnorderedFunction",
                 [IsPartitionStack, IsTracer, IsPosInt, IsFunction]);

#! @Description
#! Apply <C>PS_SplitCellByUnorderedFunction</C> to every active cell in the
#! partition stack <A>PS</A>.
#!
#! @Arguments PS, t, f
DeclareOperation("PS_SplitCellsByUnorderedFunction",
                 [IsPartitionStack, IsTracer, IsFunction]);

DeclareOperation("PS_UNSAFE_CellSlice", [IsPartitionStack, IsPosInt]);

DeclareOperation("PS_UNSAFE_FixupCell", [IsPartitionStack, IsPosInt]);

DeclareInfoClass("InfoPartitionStack");
SetInfoLevel(InfoPartitionStack, 1);
