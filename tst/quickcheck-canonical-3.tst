#@local lmp
gap> START_TEST("quickcheck-canonical-3.tst");
gap> LoadPackage("backtrackkit", false);
true
gap> LoadPackage("quickcheck", false);;

#
gap> lmp := {l...} -> Maximum(1,Maximum(List(l, LargestMovedPoint)));;
gap> QC_SetConfig(rec(limit := 6));
gap> QC_Check([IsPerm, QC_ListOf(IsPosInt)], 
> function(perm,s)
>   local m,s2,can1,can2,p1;
>   s2 := OnTuples(s,perm);
>   m := Maximum(LargestMovedPoint(perm), Maximum(1,Maximum(s)));
>   can1 :=  BTKit_SimpleCanonicalSearch(PartitionStack(m), [BTKit_Con.TupleStab(s)]);
>   can2 :=  BTKit_SimpleCanonicalSearch(PartitionStack(m), [BTKit_Con.TupleStab(s2)]);
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
gap> STOP_TEST("quickcheck-canonical-3.tst");
