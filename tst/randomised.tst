gap> START_TEST("randomised.tst");
gap> LoadPackage("backtrackkit", false);
true

#
gap> ReadPackage("BacktrackKit", "tst/test_functions.g");;
gap> BTKit_IntersectionTestSizes := [5..15];;
gap> IntersectionTests(50);
true

#
gap> STOP_TEST("randomised.tst");
