gap> LoadPackage("backtrackkit", false);;
gap> LoadPackage("digraphs", false);;
gap> ToBTKit_Graph := function(g, verts)
>    local graph, max, edge, i;
>    graph := List([1..verts], x -> []);
>    for edge in DigraphEdges(g) do
>        Add(graph[edge[1]], [1,edge[2]]);
>    od;
>    for i in [1..Length(graph)] do
>      Sort(graph[i]);
>    od;
>    return graph;
> end;;
gap> testGraph := function(graph,verts)
> local g1, g2, btgraph, ps;
> ps := PartitionStack(verts);
> btgraph := ToBTKit_Graph(graph, verts);
> g1 := BTKit_SimpleSearch(ps, [BTKit_Con.GraphTrans( btgraph, btgraph)]);
> g2 := DigraphGroup(graph);
> if g1 <> g2 then PrintFormatted("failure: {} {} {}", graph, g1, g2); fi;
> end;;
gap> dir := DirectoriesPackageLibrary( "BacktrackKit", "tst" );;
gap> graphs := ReadDigraphs(Filename(dir, "graph6.g6"));;
gap> for g in graphs do testGraph(g, 6); od;
