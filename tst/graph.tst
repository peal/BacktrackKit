gap> LoadPackage("backtrackkit", false);;
gap> LoadPackage("digraphs", false);;
gap> testGraph := function(graph,verts)
> local g1, g2, ps;
> ps := PartitionStack(verts);
> g1 := BTKit_SimpleSearch(ps, [BTKit_Con.GraphTrans(graph, graph)]);
> g2 := AutomorphismGroup(graph);
> if g1 <> g2 then PrintFormatted("failure: {} {} {}", graph, g1, g2); fi;
> end;;
gap> dir := DirectoriesPackageLibrary( "BacktrackKit", "tst" );;
gap> graphs := ReadDigraphs(Filename(dir, "graph6.g6"));;
gap> for g in graphs do testGraph(g, 6); od;
