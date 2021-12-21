#
# BacktrackKit: An extensible, easy to understand backtracking framework
#

_STANDREWSCS := Concatenation(["Jack Cole Building, North Haugh, ",
                               "St Andrews, Fife, KY16 9SX, Scotland"]);

SetPackageInfo( rec(

PackageName := "BacktrackKit",
Subtitle := "An extensible, easy to understand backtracking framework",
Version := "0.6.1",
Date := "21/12/2021", # dd/mm/yyyy format


Persons := [
  rec(
    IsAuthor := true,
    IsMaintainer := true,
    FirstNames := "Christopher",
    LastName := "Jefferson",
    WWWHome := "http://caj.host.cs.st-andrews.ac.uk/",
    Email := "caj21@st-andrews.ac.uk",
    PostalAddress := Concatenation(
               "School of Computer Science\n",
               "University of St Andrews\n",
               "Jack Cole Building, North Haugh\n",
               "St Andrews, Fife, KY16 9SX\n",
               "United Kingdom" ),
    Place := "St Andrews",
    Institution := "University of St Andrews",
  ),
  rec(
    LastName      := "Wilson",
    FirstNames    := "Wilf A.",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "gap@wilf-wilson.net",
    WWWHome       := "https://wilf.me",
  ),
  rec(
    LastName      := "Pfeiffer",
    FirstNames    := "Markus",
    IsAuthor      := false,
    IsMaintainer  := false,
    Email         := "markus.pfeiffer@morphism.de",
    WWWHome       := "https://markusp.morphism.de",
  ),
],

SourceRepository := rec(
    Type := "git",
    URL := "https://github.com/peal/BacktrackKit",
),
IssueTrackerURL := Concatenation( ~.SourceRepository.URL, "/issues" ),
PackageWWWHome  := "https://peal.github.io/BacktrackKit",
PackageInfoURL  := Concatenation( ~.PackageWWWHome, "PackageInfo.g" ),
README_URL      := Concatenation( ~.PackageWWWHome, "README.md" ),
ArchiveURL      := Concatenation( ~.SourceRepository.URL,
                                 "/releases/download/v", ~.Version,
                                 "/", ~.PackageName, "-", ~.Version ),

ArchiveFormats := ".tar.gz",

##  Status information. Currently the following cases are recognized:
##    "accepted"      for successfully refereed packages
##    "submitted"     for packages submitted for the refereeing
##    "deposited"     for packages for which the GAP developers agreed
##                    to distribute them with the core GAP system
##    "dev"           for development versions of packages
##    "other"         for all other packages
##
Status := "dev",

AbstractHTML :=  "",

PackageDoc := rec(
  BookName  := "BacktrackKit",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "An extensible, easy to understand backtracking framework",
),

Dependencies := rec(
  GAP := ">= 4.11",
  NeededOtherPackages := [
                           ["datastructures", ">=0.2.6"],
                           ["digraphs", ">=1.1.1" ],
                           ["images", ">=1.3.0"],   # For MinimalImagePerm
                           ["primgrp", ">=3.4.0" ], # For the tests
                         ],
  SuggestedOtherPackages := [ ],
  ExternalConditions := [ ],
),

AvailabilityTest := ReturnTrue,

TestFile := "tst/testall.g",

#Keywords := [ "TODO" ],

));
