#@local testGraph, dir, graphs, g
gap> LoadPackage("backtrackkit", false);;
gap> LoadPackage("QuickCheck", false);;
gap> testGraph := function(graph,verts)
> local g1, g2, ps;
> ps := PartitionStack(verts);
> g1 := BTKit_SimpleSearch(ps, [BTKit_Con.GraphTrans(graph, graph)]);
> g2 := AutomorphismGroup(graph);
> if g1 <> g2 then PrintFormatted("failure: {} {} {}", graph, g1, g2); fi;
> end;;
gap> dir := DirectoriesPackageLibrary( "BacktrackKit", "tst" );;
gap> graphs := Concatenation(List([2..6], {x} -> ReadDigraphs(Filename(dir, StringFormatted("graphs/graph{}.g6",x)))));;
gap> for g in graphs do testGraph(g, Maximum(DigraphVertices(g))); od;
