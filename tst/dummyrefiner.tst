#@local con, ref, found, p
gap> START_TEST("dummyrefiner.tst");
gap> LoadPackage("backtrackkit", false);
true

# A constraint with no specialised refiner falls back to a DummyRefiner. This
# performs no refinement, but the search still returns correct results because
# each candidate is verified against the constraint directly (a brute-force
# solution check). Here OnSetsSets has no specialised refiner.
gap> con := Constraint.Stabilise(Set([[1,2,3],[4,5,6]]), OnSetsSets);;
gap> ref := BTKit_RefinerFromConstraint(con);;
gap> StartsWith(ref!.name, "Dummy");
true
gap> found := BTKit_SimpleSearch(PartitionStack(6), [ref]);;
gap> found = Stabilizer(SymmetricGroup(6), Set([[1,2,3],[4,5,6]]), OnSetsSets);
true

# The same fallback for a transporter (set-of-sets) constraint: the
# single-permutation search must return a genuine witness.
gap> con := Constraint.Transport(Set([[1,2],[3,4]]), Set([[1,3],[2,4]]), OnSetsSets);;
gap> ref := BTKit_RefinerFromConstraint(con);;
gap> StartsWith(ref!.name, "Dummy");
true
gap> p := BTKit_SimpleSinglePermSearch(PartitionStack(4), [ref]);;
gap> p <> fail and OnSetsSets(Set([[1,2],[3,4]]), p) = Set([[1,3],[2,4]]);
true

# A non-transportable set-of-sets pair must yield no witness.
gap> con := Constraint.Transport(Set([[1,2],[3,4]]), Set([[1,2,3],[4]]), OnSetsSets);;
gap> BTKit_SimpleSinglePermSearch(PartitionStack(4), [BTKit_RefinerFromConstraint(con)]);
fail

#
gap> STOP_TEST("dummyrefiner.tst");
