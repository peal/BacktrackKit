
# Filters a partition stack by a graph, a single step
# The graph should be in the following format:
# graph[i] is the neighbours of vertex i.
# A neighbour should be a list [colour, neighbour],
# where neighbour is another vertex and colour is the 'colour' of the edge.
# For undirected graphs be sure to put the edge in, in both directions.
# For directed graphs, make the 'colour' of the edge in both directions different
# (for example 1 in the forward direction, -1 in the backward direction)
BTKit_FilterGraph := function(ps, graph)
    local list, points, i;
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
od;

# Check if graph1^p = graph2
BTKit_GraphEqualPerm := function(p, graph1, graph2)
    local i, edgemap;
    for i in 

BTKit_Con.GraphStab := function(name, graphL, graphR)
    local filters;
    return rec(
        name := name,
        check := {p} -> ForAll([1..Length(fixlist)], {i} -> fixlist[i] = fixlist[i^p]),
        refine := rec(
            initalise := function(ps, rbase)
                return filters;
            end)
    );
end;

# Make a refiner which accepts permutations p
# such that fixlistL[i] = fixlistR[i^p]
BTKit_Con.GraphStab := function(name, fixlistL, fixlistR)
    local filtersL, filtersR;
    filtersL := [rec(partition := {i} -> fixlistL[i])];
    filtersR := [rec(partition := {i} -> fixlistR[i])];
    return rec(
        name := name,
        check := {p} -> ForAll([1..Length(fixlistL)], {i} -> fixlistL[i] = fixlistR[i^p]),
        refine := rec(
            initalise := function(ps, rbase)
                if rbase = fail then
                    return filtersL;
                else
                    return filtersR;
                fi;
            end)
    );
end;
