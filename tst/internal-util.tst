#@local gens, r, rt, p, d1, d2
gap> START_TEST("internal-util.tst");
gap> LoadPackage("backtrackkit", false);
true

# _BTKit.bfsOrbit: breadth-first orbit of a seed under a generating set,
# returning the orbit and a point -> BFS-position map.
gap> gens := [(1,2,3,4,5), (1,2)];;
gap> r := _BTKit.bfsOrbit(1, gens);;
gap> Set(r.orbit) = Set(Orbit(Group(gens), 1));
true
gap> r.position[1] = 1;
true
gap> ForAll([1 .. Length(r.orbit)], i -> r.position[r.orbit[i]] = i);
true

# _BTKit.bfsOrbitWithTrace additionally records, for each orbit point p, an
# element of <gens> mapping the seed to p.
gap> rt := _BTKit.bfsOrbitWithTrace(2, gens);;
gap> Set(rt.orbit) = Set(Orbit(Group(gens), 2));
true
gap> ForAll(rt.orbit, p -> 2 ^ rt.treeElement[p] = p);
true

# _BTKit.partitionByKey groups a list by the value of a key function.
gap> p := _BTKit.partitionByKey([1 .. 10], x -> x mod 3);;
gap> Set(p[0]) = [3, 6, 9] and Set(p[1]) = [1, 4, 7, 10] and Set(p[2]) = [2, 5, 8];
true

# _BTKit.orbitalEquivalenceKey is an isomorphism invariant: relabelling a
# digraph must not change its key.
gap> d1 := CycleDigraph(5);;
gap> d2 := OnDigraphs(d1, (1,2,3,4,5));;
gap> _BTKit.orbitalEquivalenceKey(d1) = _BTKit.orbitalEquivalenceKey(d2);
true

#
gap> STOP_TEST("internal-util.tst");
