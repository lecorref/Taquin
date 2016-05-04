# N-Puzzle

[![travis-badge][]][travis] [![license-badge][]][license]

[travis-badge]: https://travis-ci.org/lecorref/Taquin.svg?branch=master&style=flat-square
[travis]: https://travis-ci.org/lecorref/Taquin
[license-badge]: https://img.shields.io/badge/license-GPL_3-green.svg?style=flat-square

## Usage
```
Npuzzle solver

Usage: npuzzle [-h|--help] [-l|--load FILE] [-b|--goal FILE] [-q|--qsize SIZE]
               [-g|--generate SIZE] [-p|--print] [-r|--randomize MOVES] [-c|--cost FUNCTION]
               [-e|--heuristic FUNCTION] [FREE-ARGS]

Available options:
  -h, --help               Print usage
  -l, --load FILE          Parse the puzzle from file
  -b, --goal FILE          Parse the goal puzzle from file
  -q, --qsize SIZE         Maximum size of priority queue, in thousand. Default 200; min 100
  -g, --generate SIZE      Generate puzzle with given size
  -p, --print              Print each passed states
  -r, --randomize MOVES    Use with generate. number of random moves
  -c, --cost FUNCTION      choose how the heuritic function will be valued. Values: uniform; squared; greedy
  -e, --heuristic FUNCTION The program will use the provided heuristic function (default linear-conflict)

heuristics: manhattan; linear-conflict, misplaced-tiles, n-maxswap

User options are not processed by SBCL. All runtime options must
appear before toplevel options, and all toplevel options must
appear before user options.

For more information please refer to the SBCL User Manual, which
should be installed along with SBCL, and is also available from the
website <http://www.sbcl.org/>.
```

How to build and run:
```shell
make build
./npuzzle --show --load <(python npuzzle-gen.py --solvable 5)
```

How to check test the program:
```shell
make run_test
```
How to check bench the program:
```shell
make run_bench
```

## Knowledge
This is a reading list of material relevant to *N-Puzzle*. It includes prior research that has - at one time or another - influenced the design of *N-Puzzle*, as well as publications about *N-Puzzle*.
* [Solvability](http://www.cs.bham.ac.uk/~mdr/teaching/modules04/java2/TilesSolvability.html)
* [Astar search](https://en.wikipedia.org/wiki/A*_search_algorithm)
* [Heuristic](https://heuristicswiki.wikispaces.com/)

## License
*N-Puzzle*'s code in this repo uses the [GNU GPL v3](http://www.gnu.org/licenses/gpl-3.0.html) [license][license].

[license]: LICENSE
