# Taquin

resolve board without intermediate information of resolution:

    npuzzle <(python npuzzle-gen.py --solvable 5)


resolve board with intermediate information of resolution:

    npuzzle --show <(python npuzzle-gen.py --solvable 5)


resolve board with a specific heuristic between manhattan, conflicts, linear-conflict, misplaced-tiles or n-maxswap:

    npuzzle --heuristic linear-conflict <(python npuzzle-gen.py --solvable 5)


resolve board with a specific heuristic and intermediate information:

    npuzzle --heuristic linear-conflict --show <(python npuzzle-gen.py --solvable 5)


resolve board with another board's goal:

    npuzzle --show --load <(python npuzzle-gen.py --solvable 5)  --goal <(python npuzzle-gen.py --solvable 5)

# Basic Usage

run solver with boards:

    npuzzle [<option -h, --heuristic>, <options -s, --show>, <board.npuzzle, ...>]
