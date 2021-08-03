DeclareInfoClass("InfoBTKitTest");

if not IsBound(BTKit_CentralizerTestSizes) then
    BTKit_CentralizerTestSizes := [20..50];
fi;

if not IsBound(BTKit_IntersectionTestSizes) then
    BTKit_IntersectionTestSizes := [50..100];
fi;

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

PermCentralizerTests := function(k)
    local g, e, t, i, d, ps, gap, btkit;

    Info(InfoBTKitTest, 5, "Creating \"random\" group");
    g := DirectProduct(List([1..2], x -> RandomPrimitiveGroup(GlobalMersenneTwister, BTKit_CentralizerTestSizes)));
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
        btkit := BTKit_SimpleSearch(ps, [ BTKit_Con.InGroup(g), BTKit_Con.PermCentralizer(e) ] );
        t := NanosecondsSinceEpoch() - t;
        Info(InfoBTKitTest, 5, "BTKit:  ", t / 1000000000., " size: ", Size(btkit));

        if gap <> btkit then
            Error("GAP and BTKit disagree!\n");
        fi;
    od;
    return true;
end;

CentralizerTest := function()
    local g, h, e, l, t, i, d, p, ps, gap, btkit;

    Info(InfoBTKitTest, 5, "Creating \"random\" group");
    repeat
    g := DirectProduct(List([1..2], x -> RandomPrimitiveGroup(GlobalMersenneTwister, BTKit_CentralizerTestSizes)));
    h := DirectProduct(List([1..2], x -> RandomPrimitiveGroup(GlobalMersenneTwister, BTKit_CentralizerTestSizes)));
    h := Intersection(g,h);
    until not IsTrivial(h);

    d := LargestMovedPoint(g);
    p := Random(GlobalMersenneTwister, SymmetricGroup(d));
    g := g ^ p;
    h := h ^ p;

    Info(InfoBTKitTest, 5, " done, on ", d, " points");
    ps := PartitionStack(d);

    g := Group(GeneratorsOfGroup(g));
    h := Group(GeneratorsOfGroup(h));

    t := NanosecondsSinceEpoch();
    gap := Centralizer(g, h);
    t := NanosecondsSinceEpoch() - t;
    Info(InfoBTKitTest, 5, "GAP:    ", t / 1000000000., " size: ", Size(gap));

    g := Group(GeneratorsOfGroup(g));

    l := List(GeneratorsOfGroup(h), x -> BTKit_Con.PermCentralizer(x));
    Add(l, BTKit_Con.InGroup(g));

    t := NanosecondsSinceEpoch();
    btkit := BTKit_SimpleSearch(ps, l);
    t := NanosecondsSinceEpoch() - t;
    Info(InfoBTKitTest, 5, "BTKit:  ", t / 1000000000., " size: ", Size(btkit));

    if gap <> btkit then
        Error("GAP and BTKit disagree!\n");
    fi;

    return true;
end;

IntersectionTests := function(k)
    local g, h, e, t, i, d, ps, gap, btkit, btkitorb;

    for i in [1..k] do
        Info(InfoBTKitTest, 5, "Creating \"random\" groups");
        g := DirectProduct(List([1..2], x -> RandomPrimitiveGroup(GlobalMersenneTwister, BTKit_IntersectionTestSizes)));
        h := DirectProduct(List([1..2], x -> RandomPrimitiveGroup(GlobalMersenneTwister, BTKit_IntersectionTestSizes)));

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
        btkit := BTKit_SimpleSearch(ps, [ BTKit_Con.InGroup(g), BTKit_Con.InGroup(h) ] );
        t := NanosecondsSinceEpoch() - t;
        Info(InfoBTKitTest, 5, "BTKit:  ", t / 1000000000., " size: ", Size(btkit));

        btkitorb := BTKit_SimpleSearch(ps, [ BTKit_Con.InGroupWithOrbitals(g), BTKit_Con.InGroupWithOrbitals(h) ] );

        if gap <> btkit then
            Error("ERROR: GAP and BTKit disagree!\n");
        fi;
        if btkit <> btkitorb then
            Error("ERROR: BTKit with and without orbitals disagree!\n");
        fi;
    od;
    return true;
end;
