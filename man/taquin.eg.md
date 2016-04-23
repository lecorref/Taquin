# Taquin

resolve board without intermediate information of resolution:

    taquin inputs/solvable_five.npuzzle


resolve board with intermediate information of resolution:

    taquin --show inputs/solvable_five.npuzzle


resolve board with a specific heuristic between manhattan, conflicts, linear-conflict, misplaced-tiles or n-maxswap:

    taquin --heuristic linear-conflict inputs/solvable_five.npuzzle


resolve board with a specific heuristic and intermediate information:

    taquin --heuristic linear-conflict --show inputs/solvable_five.npuzzle


# Basic Usage

run solver with boards:

    bomberman [<option -h, --heuristic>, <options -s, --show>, <board.npuzzle, ...>]
