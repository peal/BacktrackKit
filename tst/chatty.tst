#@local ps3, ps6, G, p, graph, g1, g2
gap> START_TEST("chatty.tst");
gap> LoadPackage("backtrackkit", false);
true

#
gap> ps3 := PartitionStack(3);
[ [ 1, 2, 3 ] ]
gap> G := BTKit_SimpleSearch(ps3, [_BTKit.ChattyRefiner()]);; Print("\n");
initialise:1
changed:1
fixed:1
changed:2
fixed:2
changed:3
fixed:3
rBaseFinished
initialise:1
changed:1
fixed:1
changed:2
 fixed:2
 changed:3
  fixed:3
  solutionFound:()
  changed:3
  fixed:3
  solutionFound:(2,3)
  changed:2
 fixed:2
 changed:3
  fixed:3
  solutionFound:(1,2)
  changed:2
 fixed:2
 changed:3
  fixed:3
  solutionFound:(1,3,2)
  
gap> G = SymmetricGroup(3);
true

#
gap> STOP_TEST("basic.tst");
