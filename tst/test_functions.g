DeclareInfoClass("InfoBTKitTest");

# Select a primitive group uniformly at random amongst all
# primitive groups with degrees <degrees> using random source
# <rdsrc>
RandomPrimitiveGroup := function(rdsrc, degrees)
    local i, l, nr;

    l := List(degrees, NrPrimitiveGroups);
    nr := Random(rdsrc, [1..Sum(l)]);

    i := 1;
    repeat
        nr := nr - l[i];
        i := i + 1;
    until nr <= 0;
    return PrimitiveGroup(degrees[i-1], nr + l[i-1]);
end;

RandomTransitiveGroup := function(rdsrc, degrees)
    local i, l, nr;

    l := List(degrees, NrTransitiveGroups);
    nr := Random(rdsrc, [1..Sum(l)]);

    i := 1;
    repeat
        nr := nr - l[i];
        i := i + 1;
    until nr <= 0;
    return TransitiveGroup(degrees[i-1], nr + l[i-1]);
end;

CentralizerTests := function(k)
    local g, e, t, i, d, ps, gap, btkit;

    Info(InfoBTKitTest, 5, "Creating \"random\" group");
    g := DirectProduct(List([1..2], x -> RandomPrimitiveGroup(GlobalMersenneTwister, [20..50])));
    Info(InfoBTKitTest, 5, " making stabilizer chain");
    d := LargestMovedPoint(g);
    g := g ^ Random(GlobalMersenneTwister, SymmetricGroup(d));
    StabChain(g);

    Info(InfoBTKitTest, 5, " done, on ", d, " points");
    Info(InfoBTKitTest, 5, " testing ", k, " random element centralizers");
    for i in [1..k] do
        ps := PartitionStack(d);
        e := Random(g);

        g := Group(GeneratorsOfGroup(g));
        t := NanosecondsSinceEpoch();
        gap := Centralizer(g, e);
        t := NanosecondsSinceEpoch() - t;
        Info(InfoBTKitTest, 5, "GAP:    ", t / 1000000000., " size: ", Size(gap));

        g := Group(GeneratorsOfGroup(g));
        t := NanosecondsSinceEpoch();
        btkit := BTKit_SimpleSearch(ps, [ BTKit_Con.InGroup(d, g), BTKit_Con.EltCentralizer(d, e) ] );
        t := NanosecondsSinceEpoch() - t;
        Info(InfoBTKitTest, 5, "BTKit:  ", t / 1000000000., " size: ", Size(btkit));

        if gap <> btkit then
            Error("GAP and BTKit disagree!\n");
        fi;
    od;
    return true;
end;

IntersectionTests := function(k)
    local g, h, e, t, i, d, ps, gap, btkit;

    for i in [1..k] do
        Info(InfoBTKitTest, 5, "Creating \"random\" groups");
        g := DirectProduct(List([1..2], x -> RandomPrimitiveGroup(GlobalMersenneTwister, [50..100])));
        h := DirectProduct(List([1..2], x -> RandomPrimitiveGroup(GlobalMersenneTwister, [50..100])));

        d := Maximum(LargestMovedPoint(g), LargestMovedPoint(h));
        g := g ^ Random(GlobalMersenneTwister, SymmetricGroup(d));
        h := h ^ Random(GlobalMersenneTwister, SymmetricGroup(d));

        Info(InfoBTKitTest, 5, " making stabilizer chain");
        StabChain(g); StabChain(h);
        d := Maximum(LargestMovedPoint(g), LargestMovedPoint(h));
        ps := PartitionStack(d);

        Info(InfoBTKitTest, 5, " done, on ", d, " points");

        g := Group(GeneratorsOfGroup(g));
        h := Group(GeneratorsOfGroup(h));
        t := NanosecondsSinceEpoch();
        gap := Intersection(g, h);
        t := NanosecondsSinceEpoch() - t;
        Info(InfoBTKitTest, 5, "GAP:    ", t / 1000000000., " size: ", Size(gap));

        g := Group(GeneratorsOfGroup(g));
        h := Group(GeneratorsOfGroup(h));
        t := NanosecondsSinceEpoch();
        btkit := BTKit_SimpleSearch(ps, [ BTKit_Con.InGroup(d, g), BTKit_Con.InGroup(d, h) ] );
        t := NanosecondsSinceEpoch() - t;
        Info(InfoBTKitTest, 5, "BTKit:  ", t / 1000000000., " size: ", Size(btkit));

        if gap <> btkit then
            Error("ERROR: GAP and BTKit disagree!\n");
        fi;
    od;
    return true;
end;
