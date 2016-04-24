# N-Puzzle

[![travis-badge][]][travis] [![license-badge][]][license]

[travis-badge]: https://travis-ci.org/lecorref/Taquin.svg?branch=master&style=flat-square
[travis]: https://travis-ci.org/lecorref/Taquin
[license-badge]: https://img.shields.io/badge/license-GPL_3-green.svg?style=flat-square

## Usage
```
Usage: [options] arg1.npuzzle [...]
Options:
  -s, --show             show intermediate information of resolution
```

How to check test the program:
```shell
make test
```

How to run with *Makefile*:
```shell
make ARGS="--show --load inputs/solvable_five.npuzzle" script
```
How to run with *sbcl* and dynamic input:
```shell
sbcl --script src/main.lisp --show --load <(python npuzzle-gen.py --solvable 5)
```

## Knowledge
This is a reading list of material relevant to *N-Puzzle*. It includes prior research that has - at one time or another - influenced the design of *N-Puzzle*, as well as publications about *N-Puzzle*.
* [Solvability](http://www.cs.bham.ac.uk/~mdr/teaching/modules04/java2/TilesSolvability.html)

## License
*N-Puzzle*'s code in this repo uses the [GNU GPL v3](http://www.gnu.org/licenses/gpl-3.0.html) [license][license].

[license]: LICENSE
