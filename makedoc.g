# BacktrackKit: An extensible, easy to understand backtracking framework
# A GAP package
#
# License info:
#
# This file is a script which compiles the package manual.

if LoadPackage("AutoDoc", "2019.09.04") = fail then
    ErrorNoReturn("AutoDoc version 2019.09.04 or newer is required to compile ",
                  "the manual.");
fi;

AutoDoc(
    rec(
        scaffold := true,
        autodoc := true,
        extract_examples := rec(
            skip_empty_in_numbering := false,
        ),
    )
);

QUIT;
