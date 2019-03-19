
# Filters a partition stack by a graph, a single step
# The graph should be in the following format:
# graph[i] is the neighbours of vertex i.
# A neighbour should be a list [colour, neighbour],
# where neighbour is another vertex and colour is the 'colour' of the edge.
# For undirected graphs be sure to put the edge in, in both directions.
# For directed graphs, make the 'colour' of the edge in both directions different
# (for example 1 in the forward direction, -1 in the backward direction)
BTKit_FilterGraph := function(ps, graph)
    local list, points, i, j;
    points := PS_Points(ps);
    list := [];
    for i in [1..points] do
        list[i] := [];
        for j in graph[i] do
            Add(list[i], [j[1], PS_CellOfPoint(ps, j[2])]);
        od;
        Sort(list[i]);
    od;
    return list;
end;

BTKit_OnGraph := function(p, graph)
    local graphimg, neighbours,i,j;
    graphimg := [];
    for i in [1..Length(graph)] do
        neighbours := [];
        for j in graph[i] do
            Add(neighbours, [j[1], j[2]^p]);
        od;
        graphimg[i^p] := SortedList(neighbours);
    od;
    return graphimg;
end;


# Make a refiner which accepts permutations p
# such that fixlistL[i] = fixlistR[i^p]
BTKit_Con.GraphTrans := function(graphL, graphR)
    local filtersL, filtersR, check;
    # Give an initial sort
    graphL := List(graphL, SortedList);
    graphR := List(graphR, SortedList);
    check := function(ps, buildingRBase)
                local filt;
                if buildingRBase then
                    filt := BTKit_FilterGraph(ps, graphL);
                else
                    filt := BTKit_FilterGraph(ps, graphR);
                fi;
                return {x} -> filt[x];
            end;
    return rec(
        name := "GraphTrans",
        check := {p} -> BTKit_OnGraph(p, graphL) = graphR,
        refine := rec(
            initalise := check, 
            changed := check
        )
    );
end;
