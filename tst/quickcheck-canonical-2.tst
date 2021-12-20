#@local lmp
gap> START_TEST("quickcheck-canonical-2.tst");
gap> LoadPackage("quickcheck", false);;
gap> LoadPackage("backtrackkit", false);
true

#
gap> lmp := {l...} -> Maximum(1,Maximum(List(l, LargestMovedPoint)));;
gap> QC_SetConfig(rec(limit := 6));
gap> QC_Check([IsPerm, QC_SetOf(IsPosInt)], 
> function(perm,s)
>   local m,s2,can1,can2,p1;
>   s2 := OnSets(s,perm);
>   m := Maximum(LargestMovedPoint(perm), Maximum(Concatenation([1], s)));
>   can1 :=  BTKit_SimpleCanonicalSearch(PartitionStack(m), [BTKit_Refiner.SetStab(s)]);
>   can2 :=  BTKit_SimpleCanonicalSearch(PartitionStack(m), [BTKit_Refiner.SetStab(s2)]);
>   if can1.image <> can2.image then
>     return StringFormatted("Images Different: {},{},{},{}",s,s2,can1,can2);
>   fi;
>   for p1 in can1.perms do
>      if [OnSets(s,p1)] <> can1.image then
>        return StringFormatted("Incorrect image: {}^{} = {}, not {}", s, p1, OnSets(s,p1), can1.image);
>      fi;
>   od;
>  return true;
> end);
true
gap> QC_Check([IsPermGroup, QC_SetOf(IsPosInt)], 
> function(g,s)
>   local perm,m,s2,can1,can2,p1;
>   perm := Random(g);
>   s2 := OnSets(s,perm);
>   m := Maximum(LargestMovedPoint(perm), LargestMovedPoint(g), Maximum(Concatenation([1], s)));
>   can1 :=  BTKit_SimpleCanonicalSearchInGroup(PartitionStack(m), [BTKit_Refiner.SetStab(s)], g);
>   can2 :=  BTKit_SimpleCanonicalSearchInGroup(PartitionStack(m), [BTKit_Refiner.SetStab(s2)], g);
>   if can1.image <> can2.image then
>     return StringFormatted("Images Different: {},{},{},{}",s,s2,can1,can2);
>   fi;
>   for p1 in can1.perms do
>      if [OnSets(s,p1)] <> can1.image then
>        return StringFormatted("Incorrect image: {}^{} = {}, not {}", s, p1, OnSets(s,p1), can1.image);
>      fi;
>   od;
>  return true;
> end);
true
gap> QC_Check([IsPerm, QC_ListOf(IsPosInt)], 
> function(perm,s)
>   local m,s2,can1,can2,p1;
>   s2 := OnTuples(s,perm);
>   m := Maximum(LargestMovedPoint(perm), Maximum(Concatenation([1], s)));
>   can1 :=  BTKit_SimpleCanonicalSearch(PartitionStack(m), [BTKit_Refiner.TupleStab(s)]);
>   can2 :=  BTKit_SimpleCanonicalSearch(PartitionStack(m), [BTKit_Refiner.TupleStab(s2)]);
>   if can1.image <> can2.image then
>     return StringFormatted("Images Different: {},{},{},{}",s,s2,can1,can2);
>   fi;
>   for p1 in can1.perms do
>      if [OnTuples(s,p1)] <> can1.image then
>        return StringFormatted("Incorrect image: {}^{} = {}, not {}", s, p1, OnTuples(s,p1), can1.image);
>      fi;
>   od;
>  return true;
> end);
true

#
gap> STOP_TEST("quickcheck-canonical-2.tst");
