gap> LoadPackage("BacktrackKit", false);
true
gap> ReadPackage("BacktrackKit", "tst/test_functions.g");;
gap> BTKit_CentralizerTestSizes := [5..20];;
gap> PermCentralizerTests(100);
true
gap> CentralizerTest();
true
