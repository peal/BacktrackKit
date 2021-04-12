gap> LoadPackage("BacktrackKit", false);
true
gap> ReadPackage("BacktrackKit", "tst/test_functions.g");;
gap> BTKit_IntersectionTestSizes := [5..15];;
gap> IntersectionTests(50);
true