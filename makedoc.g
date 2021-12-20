# BacktrackKit: An extensible, easy to understand backtracking framework
# A GAP package by Christopher Jefferson and Wilf A. Wilson.
#
# License info:
#
# This file is a script which compiles the package manual.

if LoadPackage("AutoDoc", "2019.09.04") = fail then
    ErrorNoReturn("AutoDoc version 2019.09.04 or newer is required to compile ",
                  "the manual.");
fi;

_btkitinfo := PackageInfo("backtrackkit")[1];
_strip := function(str)
  str := ReplacedString(str, ">=", "");
  str := ReplacedString(str, " ", "");
  return str;
end;

_autodoc := rec(
    autodoc := rec(
        files := [
                   "doc/intro.autodoc",
                   "gap/BacktrackKit.gd",
                   "gap/constraint.gd",
                   "gap/refiner.gd",
                   "gap/partitionstack.gd",
                   "gap/tracer.gd",
                   "gap/canonical.gd",
                   "examples/partitionstack.autodoc",
                   "examples/refiner.autodoc",
                 ],
        scan_dirs := [
                     ],
    ),
    extract_examples := rec(
        skip_empty_in_numbering := false,
    ),
    gapdoc := rec(
        gap_root_relative_path := true,
    ),
    scaffold := rec(
        appendix := [
                    ],
        includes := [
                    ],
        entities := rec(
            BTKitWWW     := _btkitinfo.PackageWWWHome,
            BTKitIssues  := _btkitinfo.IssueTrackerURL,
            BTKitVersion := _strip(_btkitinfo.Version),
            GAPVersion   := _strip(_btkitinfo.Dependencies.GAP),
            BTKitYear    := _btkitinfo.Date{[7..10]},
        ),
        bib := "btkit.bib",
        index := true,
        MainPage := true,
    ),
);

_entities := _autodoc.scaffold.entities;
for _dep in Concatenation(_btkitinfo.Dependencies.NeededOtherPackages,
                          _btkitinfo.Dependencies.SuggestedOtherPackages) do
    # &PackageName; -> <Package>PackageName</Package>
    _entities.(_dep[1]) := StringFormatted("<Package>{}</Package>", _dep[1]);
    # &PackageNameVersion; -> X.Y.Z
    _name := Concatenation(_dep[1], "Version");
    _entities.(_name) := _strip(_dep[2]);
od;

AutoDoc(_autodoc);

QUIT;
