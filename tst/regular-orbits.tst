# Assisted-by: OpenAI Codex (GPT-6), regular-orbit cache regressions.
#@local H, data, other
gap> START_TEST("regular-orbits.tst");
gap> LoadPackage("backtrackkit", false);
true

# Normalisers can exchange regular orbits; callers need either orbit's
# unique representatives, not an invariant interpretation of its minimum.
gap> H := Group((1,2,3)(4,5,6));;
gap> data := StabTreeRegularOrbitData(H, 2);;
gap> other := StabTreeRegularOrbitData(H, 5);;
gap> data.regOrbitSet = [1,2,3] and other.regOrbitSet = [4,5,6];
true
gap> data.regularPoints = [1..6] and other.regularPoints = [1..6];
true
gap> ForAll([data, other], d -> ForAll(d.regOrbit,
>     p -> d.omega1 ^ d.treeE[p] = p and d.treeE[p] in H));
true
gap> IsIdenticalObj(data, StabTreeRegularOrbitData(H, 3))
>     and IsIdenticalObj(other, StabTreeRegularOrbitData(H, 4));
true
gap> StabTreeRegularOrbitData(H, 7);
fail
gap> StabTreeRegularOrbitData(SymmetricGroup(3));
fail
gap> StabTreeRegularOrbitData(Group(()));
fail

# A nonfaithful constituent is not regular even if another constituent is.
gap> H := Group((1,2,3,4,5,6)(7,8));;
gap> StabTreeRegularOrbitData(H).regularPoints = [1..6];
true
gap> StabTreeRegularOrbitData(H, 7);
fail
gap> STOP_TEST("regular-orbits.tst");
