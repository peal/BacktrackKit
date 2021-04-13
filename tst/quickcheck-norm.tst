#@local lmp
gap> START_TEST("quickcheck-norm.tst");
gap> LoadPackage("backtrackkit", false);
true
gap> LoadPackage("quickcheck", false);;

#
gap> lmp := {l...} -> Maximum(1,Maximum(List(l, LargestMovedPoint)));;
gap> QC_Check([IsPermGroup, IsPermGroup], 
> function(g1,g2)
>   local norm1, norm2, m;
>   m := lmp(g1,g2);
>   norm1 := Normaliser(g1, g2);
>   norm2 := BTKit_SimpleSearch(PartitionStack(m),
>          [BTKit_Con.InGroup(m,g1), BTKit_Con.GroupNormaliser(g2)]);
>  if norm1 <> norm2 then
>    return StringFormatted("Expected {}, got {}, from {},{}",norm1,norm2,g1,g2);
>  fi;
>  return true;
> end);
true
gap> QC_Check([IsPermGroup, IsPermGroup, IsPermGroup], 
> function(g1,g2,g3)
>   local conj, p, m;
>   m := lmp(g1,g2,g3);
>   conj := IsConjugate(g1, g2, g3);
>   p := BTKit_SimpleSinglePermSearch(PartitionStack(m),
>       [BTKit_Con.InGroup(m,g1), BTKit_Con.SimpleGroupConjugacy(g2, g3)]);
>  if conj then
>    if p = fail then return StringFormatted("Expected coset, got nothing"); fi;
>  else
>    if p <> fail then return StringFormatted("Expected nothing, got {}",p); fi;
>  fi;
>  return true;
> end);
true

#
gap> STOP_TEST("quickcheck-norm.tst");
