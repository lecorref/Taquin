CPL := sbcl
NAME := npuzzle

MAIN := src/main.lisp
TEST := test/lib.lisp

SRC := $(MAIN)
SRC += src/parser.lisp
SRC += src/algo/solution.lisp
SRC += src/algo/soluble.lisp
SRC += src/algo/astar.lisp
SRC += src/algo/puzzle.lisp
DEP := src/main.lisp

FLAGS := --script
FLAGS_TEST := --script

.PHONY: default build script run test clean
.SILENT: build test clean

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

clean:
	rm -v $(NAME) 2> /dev/null || true
