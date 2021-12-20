#@local lmp
gap> START_TEST("quickcheck-conj.tst");
gap> LoadPackage("backtrackkit", false);
true
gap> LoadPackage("quickcheck", false);;

#
gap> lmp := {l...} -> Maximum(1,Maximum(List(l, LargestMovedPoint)));;
gap> QC_Check([IsPermGroup, IsPerm], 
> function(g1,p1)
>   local norm1, norm2, m;
>   m := lmp(g1,p1);
>   norm1 := Centraliser(g1, p1);
>   norm2 := BTKit_SimpleSearch(PartitionStack(m),
>          [BTKit_Refiner.InGroup(g1), BTKit_Refiner.PermCentralizer(p1)]);
>  if norm1 <> norm2 then
>    return StringFormatted("Expected {}, got {}, from {},{}",norm1,norm2,g1,p1);
>  fi;
>  return true;
> end);
true
gap> QC_Check([IsPermGroup, IsPerm, IsPerm], 
> function(g1,p1,p2)
>   local conj, p, m;
>   m := lmp(g1,p1,p2);
>   conj := IsConjugate(g1, p1, p2);
>   p := BTKit_SimpleSinglePermSearch(PartitionStack(m),
>       [BTKit_Refiner.InGroup(g1), BTKit_Refiner.PermTransporter(p1, p2)]);
>  if conj then
>    if p = fail then return StringFormatted("Expected coset, got nothing"); fi;
>  else
>    if p <> fail then return StringFormatted("Expected nothing, got {}",p); fi;
>  fi;
>  return true;
> end);
true

#
gap> STOP_TEST("quickcheck-conj.tst");
