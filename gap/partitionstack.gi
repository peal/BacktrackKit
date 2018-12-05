##
##  This file defines partition stacks.
##

## The data structure used here is best demonstrated by example:
## The ordered partition [ [3,5], [1,2], [4] ] can be represented:

## The only required data structures are:

## vals:  [5,3,4,1,2]    - A permutation of [1..n]
## marks: [1,0,3,2,0,6]  - marks[i] = j means cell 'j' starts at index 'i'.
##                         The n+1th element of the array is fixed to n+1.
## Note that:
##   * The cells do not have to be in any particular order
##   * The values in a cell do not have to sorted.
## The main allowed operation is splitting a cell. This is done by adding
## a new integer to 'marks', which splits a current cell.
##
## There are some other data structures provided for efficient lookup:
## invvals: The inverse of vals, to find where a value exists in 'vals'.
## cellstart: marks[cellstart[i]] = i
## cellsize: The length of cell i
## fixed: A list of cells of size 1
## splits: splits[i] is the cell which was split to create cell i
##         (or -1 for splits[1])


InstallGlobalFunction(PartitionStack,
function(n)
    local marks;
    # Make array full of 0s
    marks := [1..n+1] * 0;
    marks[1] := 1;
    marks[n+1] := n+1;
    return Objectify(PartitionStackTypeMutable, 
        rec(len := n,
            vals := [1..n],
            invvals := [1..n],
            marks := marks,
            cellstart := [1],
            cellsize := [n],
            fixed := [],
            splits := [-1]));
end);

InstallMethod(IsInternallyConsistent, [IsPartitionStack],
    function(ps)
        local n, i, fixedcells, ret;
        n := ps!.len;
        if Length(ps!.marks) <> n+1 then return false; fi;
        ret := ps!.marks[1] = 1 and
               ps!.marks[n+1] = n+1;
        if not ret then return false; fi;

        if Length(ps!.cellstart) <> Length(ps!.cellsize) then return false; fi;
        if ForAny([1..n],
            {i} -> (ps!.marks[i] <> 0 and
                     (ps!.cellstart[ps!.marks[i]] <> i or
                      ps!.cellstart[ps!.marks[i]] +
                        ps!.cellsize[ps!.marks[i]] - 1 = 0)
                   )) then
            return false;
        fi;

        if ForAny([1..Length(ps!.cellstart)],
             {i} -> ps!.marks[ps!.cellstart[i]] <> i) then
             return false;
        fi;

        if Sum(ps!.cellsize) <> n then return false; fi;

        fixedcells := Filtered([1..Length(ps!.cellsize)], x -> ps!.cellsize[x] = 1);
        if Set(ps!.fixed) <> Set(fixedcells) or
           Length(Set(ps!.fixed)) = Length(ps!.fixed) then
            return false;
        fi;

        if Set(ps!.vals) <> [1..n] or Set(ps!.invvals) <> [1..n] then
            return false;
        fi;
        if ForAny([1..n], ps!.vals[ps!.invvals[i]] <> i) then
            return false;
        fi;
    end);

InstallMethod(PS_AsPartition, [IsPartitionStack],
    {ps} -> List([1..PS_Cells(ps)], c -> Set(PS_CellSlice(ps, c))) );

InstallMethod(ViewString, "for a partition stack",
    [ IsPartitionStack ],
    {ps} -> STRINGIFY(PS_AsPartition(ps)) );

InstallMethod(PS_Points, [IsPartitionStackRep],
    {ps} -> ps!.len);

InstallMethod(PS_Cells, [IsPartitionStackRep],
    {ps} -> Length(ps!.cellstart));

InstallMethod(PS_CellLen, [IsPartitionStackRep, IsPosInt],
    {ps, cell} -> ps!.cellsize[cell]);

InstallMethod(PS_CellSlice, [IsPartitionStackRep, IsPosInt],
    {ps, cell} -> Immutable(Slice(ps!.vals, ps!.cellstart[cell], ps!.cellsize[cell])));

InstallMethod(PS_FixedCells, [IsPartitionStackRep],
    {ps} -> ps!.fixed);

InstallMethod(PS_FixedPoints, [IsPartitionStackRep],
    {ps} -> List(ps!.fixed, {x} -> ps!.vals[ps!.cellstart[x]]));


InstallMethod(PS_UNSAFE_CellSlice, [IsPartitionStackRep, IsPosInt],
    {ps, cell} -> Slice(ps!.vals, ps!.cellstart[cell], ps!.cellsize[cell]));

InstallMethod(PS_UNSAFE_FixupCell, [IsPartitionStackRep, IsPosInt],
    function(ps, cell)
        local i,j;
        for i in [ps!.cellstart[cell]..ps!.cellstart[cell]+ps!.cellsize[cell]-1] do
            j := ps!.vals[i];
            ps!.invvals[j] := i;
        od;
    end);


BindGlobal("_PSR_SplitCell",
    function(ps, t, cell, index, reason)
        local splitpos, newcellid, splitcellsize;
        Assert(2, index >= 1 and index <= ps!.cellsize[cell]);
        splitpos := ps!.cellstart[cell] + index - 1;
        splitcellsize := ps!.cellsize[cell];

        newcellid := Length(ps!.cellstart) + 1;
        
        ps!.cellstart[newcellid] := splitpos;
        ps!.cellsize[newcellid] := splitcellsize - (index - 1);

        ps!.marks[splitpos] := newcellid;

        ps!.cellsize[cell] := (index - 1);

        if (index - 1) = 1 then
            Add(ps!.fixed, cell);
        fi;

        if splitcellsize - (index - 1) = 1 then
            Add(ps!.fixed, newcellid);
        fi;

        Add(ps!.splits, cell);
        return AddEvent(t, rec(oldcell := cell, newcell := newcellid,
                               oldsize := index - 1, newsize := splitcellsize - (index - 1),
                               reason := reason));
    end);

InstallMethod(PS_SplitCellsByFunction, [IsPartitionStack, IsTracer, IsFunction],
    function(ps, t, f)
        local i;
        for i in [1..PS_Cells(ps)] do
            if not PS_SplitCellByFunction(ps, t, i, f) then
                return false;
            fi;
        od;
        return true;
    end);

InstallMethod(PS_SplitCellByFunction, [IsPartitionStackRep, IsTracer, IsPosInt, IsFunction],
    function(ps, t, cell, f)
        local slice, slicelen, lastval, curval, i, success;

        slice := PS_UNSAFE_CellSlice(ps, cell);
        SortBy(slice, f);
        PS_UNSAFE_FixupCell(ps, cell);
        slicelen := Length(slice);
        lastval := f(slice[slicelen]);
        for i in [slicelen-1, slicelen-2..1] do
            curval := f(slice[i]);
            if lastval <> curval then
                if not _PSR_SplitCell(ps, t, cell, i+1, curval) then
                    return false;
                fi;
            fi;
            lastval := curval;
        od;
        return true;
    end);

InstallMethod(PS_SplitCellByUnorderedFunction, [IsPartitionStack, IsTracer, IsPosInt, IsFunction],
    function(ps, t, cell, f)
        local slice, slicelen, lastval, curval, i;

        slice := PS_UNSAFE_CellSlice(ps, cell);
        SortBy(slice, f);
        PS_UNSAFE_FixupCell(ps, cell);
        slicelen := Length(slice);
        lastval := f(slice[slicelen]);
        for i in [slicelen-1, slicelen-2..1] do
            curval := f(slice[i]);
            if lastval <> curval then
                _PSR_SplitCell(ps, cell, i+1);
            fi;
            lastval := curval;
        od;
    end);


InstallMethod(PS_RevertToCellCount, [IsPartitionStackRep, IsPosInt],
    function(ps, depth)
        local revertcell, revertstart, revertlen;
        while depth < Length(ps!.cellstart) do
            revertcell := Remove(ps!.splits);
            revertstart := Remove(ps!.cellstart);
            revertlen := Remove(ps!.cellsize);

            ps!.marks[revertstart] := 0;

            if ps!.cellsize[revertcell] = 1 then
                Remove(ps!.fixed);
            fi;

            if revertlen = 1 then
                Remove(ps!.fixed);
            fi;

            ps!.cellsize[revertcell] := ps!.cellsize[revertcell] + revertlen;
        od;
    end);
