# These functions are copied from Ferret.
# We don't use the OrbitalGraphs package, as it doesn't let us specify a 'maxval'.

_BTKit.fillRepElements := function(G, orb)
  local val, g, reps, buildorb, gens;
  reps := [];
  reps[orb[1]] := ();
  buildorb := [orb[1]];
  gens := GeneratorsOfGroup(G);
  for val in buildorb do
        for g in gens do
          if not IsBound(reps[val^g]) then
                reps[val^g] := reps[val] * g;
                Add(buildorb, val^g);
          fi;
        od;
  od;
  return reps;
end;

_BTKit.getOrbitalList := function(sc, maxval)
	local G, cutoff,
        orb, orbitsG, iorb, graph, graphlist, val, p, i, orbsizes, orbpos, innerorblist, orbitsizes,
		    biggestOrbit, skippedOneLargeOrbit, orbreps, stabtime, timefunc;
	
  if IsGroup(sc) then
    G := sc;
  else
    G := GroupStabChain(sc);
  fi;
  
  # Catch stupid case early
  if Size(G) = 1 then
    return [];
  fi;

  cutoff := infinity;

	graphlist := [];
  # Make sure orbits are sorted, so we always get the same list of graphs
	orbitsG := Set(Orbits(G,[1..maxval]), Set);
	
	orbsizes := [];
	orbpos := [];
	# Efficently store size of orbits of values
	for orb in [1..Length(orbitsG)] do
		for i in orbitsG[orb] do
			orbsizes[i] := Size(orbitsG[orb]);
			orbpos[i] := orb;
		od;
	od;

    # This gives bad times in 4.8, but I don't really care. Sorry if you ever find this.
    if IsBoundGlobal("NanosecondsSinceEpoch") then
        timefunc := ValueGlobal("NanosecondsSinceEpoch");
    else
        timefunc := function() return 0; end;
    fi;
	
    stabtime := timefunc();
	innerorblist := List(orbitsG, o -> Set(Orbits(Stabilizer(G, o[1]), [1..LargestMovedPoint(G)]), Set));
    #_YAPB_stabTime := _YAPB_stabTime + (timefunc() - stabtime);

  orbitsizes := List([1..Length(orbitsG)], 
	  x -> List(innerorblist[x], y -> Size(orbitsG[x])*Size(y)));
	
	biggestOrbit := Maximum(Flat(orbitsizes));

	skippedOneLargeOrbit := false;

	for i in [1..Size(orbitsG)] do
		orb := orbitsG[i];
    orbreps := [];
		for iorb in innerorblist[i] do
			if (Size(orb) * Size(iorb) = biggestOrbit and not skippedOneLargeOrbit) then
				skippedOneLargeOrbit := true;
			else
				if (Size(orb) * Size(iorb) <= cutoff) and
				# orbit size unchanged
				not(Size(iorb) = orbsizes[iorb[1]]) and
				# orbit size only removed one point
				not(orbpos[orb[1]] = orbpos[iorb[1]] and Size(iorb) + 1 = orbsizes[iorb[1]]) and
        # don't want to take the fixed point orbit
        not(orb[1] = iorb[1] and Size(iorb) = 1)
					then
					graph := List([1..maxval], x -> []);
          if IsEmpty(orbreps) then
            orbreps := _BTKit.fillRepElements(G, orb);
          fi;
					for val in orb do
						p := orbreps[val]; 
						graph[val] := List(iorb, x -> x^p);
					od;
					Add(graphlist, graph);
				fi;
			fi;
		od;
	od;
    #Print(sc, ":", maxval, ":", graphlist, "\n");
	return List(graphlist, {x} -> Immutable(Digraph(x)));
end;

_BTKit.InNeighboursSafe := function(graph, v)

    if v > DigraphNrVertices(graph) then
        return [];
    else
        return InNeighbours(graph)[v];
    fi;
end;

_BTKit.OutNeighboursSafe := function(graph, v)
    if v > DigraphNrVertices(graph) then
        return [];
    else
        return OutNeighbours(graph)[v];
    fi;
end;
