gap> LoadPackage("backtrackkit", false);;
gap> LoadPackage("digraphs", false);;
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
gap> QC_SetConfig(rec(limit := 6, tests := 10));
gap> for i in [1..Length(graphs)] do
> g := graphs[i];
> QC_Check([IsPerm], 
> function(perm)
>   local m,g2,can1,can2,p1;
>   Assert(0, LargestMovedPoint(perm) <= 6);
>   if Maximum(DigraphVertices(g)) < LargestMovedPoint(perm) then
>     g := DigraphAddVertices(g, LargestMovedPoint(perm) - Maximum(DigraphVertices(g)));
>   fi;
>   g2 := OnDigraphs(g,perm);
>   m := Maximum(1, Maximum(DigraphVertices(g)), LargestMovedPoint(perm));
>   can1 :=  BTKit_SimpleCanonicalSearch(PartitionStack(m), [BTKit_Con.GraphStab(g)]);
>   can2 :=  BTKit_SimpleCanonicalSearch(PartitionStack(m), [BTKit_Con.GraphStab(g2)]);
>   if can1.image <> can2.image then
>     return StringFormatted("Images Different: {},{},{},{}",g,g2,can1,can2);
>   fi;
>   for p1 in can1.perms do
>      if [OnDigraphs(g,p1)] <> can1.image then
>        return StringFormatted("Incorrect image: {}^{} = {}, not {}", g, p1, OnDigraphs(g,p1), can1.image);
>      fi;
>   od;
>  return true;
> end);
> od;
gap> for g in graphs do
> QC_Check([IsPermGroup], 
> function(group)
>   local m,g2,can1,can2,p1, perm;
>   perm := Random(group);
>   if Maximum(DigraphVertices(g)) < LargestMovedPoint(group) then
>     g := DigraphAddVertices(g, LargestMovedPoint(group) - Maximum(DigraphVertices(g)));
>   fi;
>   g2 := OnDigraphs(g,perm);
>   m := Maximum(1, Maximum(DigraphVertices(g)), LargestMovedPoint(group));
>   can1 :=  BTKit_SimpleCanonicalSearchInGroup(PartitionStack(m), [BTKit_Con.GraphStab(g)], group);
>   can2 :=  BTKit_SimpleCanonicalSearchInGroup(PartitionStack(m), [BTKit_Con.GraphStab(g2)], group);
>   if can1.image <> can2.image then
>     return StringFormatted("Images Different: {},{},{},{},{}",g,perm,g2,can1,can2);
>   fi;
>   for p1 in can1.perms do
>      if [OnDigraphs(g,p1)] <> can1.image then
>        return StringFormatted("Incorrect image: {}^{} = {}, not {}", g, p1, OnDigraphs(g,p1), can1.image);
>      fi;
>   od;
>  return true;
> end);
> od;