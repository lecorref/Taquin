CPL := sbcl
NAME := npuzzle

MAIN := src/main.lisp
TEST := test/lib.lisp
BENCH := bench/lib.lisp

SRC := $(MAIN)
SRC += src/parser.lisp
SRC += src/algo/solution.lisp
SRC += src/algo/soluble.lisp
SRC += src/algo/astar.lisp
SRC += src/algo/puzzle.lisp
DEP := src/main.lisp

FLAGS := --script
FLAGS_TEST := --script
FLAGS_BENCH := --script

.PHONY: default build script run test bench clean
.SILENT: build test bench clean

default: build

build: clean $(NAME)

$(NAME): $(DEP)
	$(CPL) $(FLAGS) $(SRC)

script:
	sbcl --script $(MAIN) $(ARGS)

run: build
	./$(NAME)

test:
	$(CPL) $(FLAGS_TEST) $(TEST)

bench:
	$(CPL) $(FLAGS_BENCH) $(BENCH)

clean:
	rm -v $(NAME) 2> /dev/null || true
