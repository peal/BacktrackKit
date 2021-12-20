#@local lmp
gap> START_TEST("quickcheck-coset.tst");
gap> LoadPackage("backtrackkit", false);
true
gap> LoadPackage("quickcheck", false);;

#
gap> lmp := {l...} -> Maximum(1,Maximum(List(l, LargestMovedPoint)));;
gap> QC_Check([IsPermGroup, IsPerm, IsPermGroup, IsPerm], 
> function(g1,p1,g2,p2)
>   local rc1,rc2,m,inter,p;
>   rc1 := RightCoset(g1,p1);
>   rc2 := RightCoset(g2,p2);
>   inter := Intersection(rc1,rc2);
>   m := lmp(g1,g2,p1,p2);
>   p := BTKit_SimpleSinglePermSearch(PartitionStack(m),
>          [BTKit_Refiner.InCoset(g1, p1), BTKit_Refiner.InCoset(g2, p2)]);
>  if inter = [] then
>    if p <> fail then return StringFormatted("Expected nothing, got {}",p); fi;
>  else
>    if not p in inter then return StringFormatted("Expected coset, got {}",p); fi;
>  fi;
>  return true;
> end);
true

#
gap> STOP_TEST("quickcheck-coset.tst");
