gap> ReadPackage("BacktrackKit", "tst/test_functions.g");;
gap> SetInfoLevel(InfoBTKit, 0);
gap> SetInfoLevel(InfoTrace, 0);
gap> BTKit_CentralizerTestSizes := [5..20];;
gap> BTKit_IntersectionTestSizes := [5..15];;
gap> PermCentralizerTests(10);
true
gap> CentralizerTest();
true
gap> IntersectionTests(10);
true
