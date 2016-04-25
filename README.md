# N-Puzzle

[![travis-badge][]][travis] [![license-badge][]][license]

[travis-badge]: https://travis-ci.org/lecorref/Taquin.svg?branch=master&style=flat-square
[travis]: https://travis-ci.org/lecorref/Taquin
[license-badge]: https://img.shields.io/badge/license-GPL_3-green.svg?style=flat-square

## Usage
```
Usage: sbcl [runtime-options] [toplevel-options] [user-options]
Common runtime options:
  --help                     Print this message and exit.
  --version                  Print version information and exit.
  --core <filename>          Use the specified core file instead of the default.
  --dynamic-space-size <MiB> Size of reserved dynamic space in megabytes.
  --control-stack-size <MiB> Size of reserved control stack in megabytes.

Common toplevel options:
  --sysinit <filename>       System-wide init-file to use instead of default.
  --userinit <filename>      Per-user init-file to use instead of default.
  --no-sysinit               Inhibit processing of any system-wide init-file.
  --no-userinit              Inhibit processing of any per-user init-file.
  --disable-debugger         Invoke sb-ext:disable-debugger.
  --noprint                  Run a Read-Eval Loop without printing results.
  --script [<filename>]      Skip #! line, disable debugger, avoid verbosity.
  --quit                     Exit with code 0 after option processing.
  --non-interactive          Sets both --quit and --disable-debugger.
Common toplevel options that are processed in order:
  --eval <form>              Form to eval when processing this option.
  --load <filename>          File to load when processing this option.

User options are not processed by SBCL. All runtime options must
appear before toplevel options, and all toplevel options must
appear before user options.

For more information please refer to the SBCL User Manual, which
should be installed along with SBCL, and is also available from the
website <http://www.sbcl.org/>.
```

How to check test the program:
```shell
make run_test
```
How to check bench the program:
```shell
make run_bench
```

How to dynamic build and run:
```shell
make build
./npuzzle --show --load <(python npuzzle-gen.py --solvable 5)
```

## Knowledge
This is a reading list of material relevant to *N-Puzzle*. It includes prior research that has - at one time or another - influenced the design of *N-Puzzle*, as well as publications about *N-Puzzle*.
* [Solvability](http://www.cs.bham.ac.uk/~mdr/teaching/modules04/java2/TilesSolvability.html)

## License
*N-Puzzle*'s code in this repo uses the [GNU GPL v3](http://www.gnu.org/licenses/gpl-3.0.html) [license][license].

[license]: LICENSE
