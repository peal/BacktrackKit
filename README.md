[![Build Status](https://github.com/peal/BacktrackKit/workflows/CI/badge.svg?branch=master)](https://github.com/peal/BacktrackKit/actions?query=workflow%3ACI+branch%3Amaster)
[![Code Coverage](https://codecov.io/github/peal/BacktrackKit/coverage.svg?branch=master&token=)](https://codecov.io/gh/peal/BacktrackKit)

# The GAP package BacktrackKit

This package provides a simple implementation of Leon's partition backtrack
framework.

BacktrackKit currently requires (currently) GAP version >= 4.11.0, and
sufficiently recent versions of the following packages (see the `PackageInfo.g`
file for specific versions):
* datastructures
* digraphs
* images
* primgrp
Additionally, [the QuickCheck
package](https://github.com/ChrisJefferson/QuickCheck) is required in order to
run all of the tests.

## Contact

This package is a work in progress, both in terms of code and documentation.

If you have any issues or questions about this package, please post an issue
at https://github.com/peal/BacktrackKit/issues


## History


0.6.1
-----

* Rename `BTKit_Con` to `BTKit_Refiner`.
* Add constraints documentation from Vole
* Add `ProcessConstraints` and `BTKit_RefinerFromConstraint`

0.6.0
-----

Refiners now have a “constraint” member, which is a new type of GAP object, and
which stores information about the constraint that the refiner refiners with
respect to.  Constraints are available via the `Constraint` record.

0.5.1
-----

Add `IsEven` and `IsOdd` refiners, to more efficiently handle alternating groups

0.5.0
-----

* Significant change to the API -- remove the requirement to give the size of the partition to most refiners
