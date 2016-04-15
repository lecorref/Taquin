CPL := sbcl
NAME := npuzzle

MAIN := src/main.lisp
TEST := test/lib.lisp

SRC := $(MAIN)
SRC += src/parser.lisp
SRC += src/algo/soluble.lisp
DEP := src/main.lisp

FLAGS := --script
FLAGS_TEST := --script

.PHONY: default build load run test clean
.SILENT: build test clean

default: build

build: clean $(NAME)

$(NAME): $(DEP)
	$(CPL) $(FLAGS) $(SRC)

load:
	sbcl --load $(MAIN) $(ARGS)

run: build
	./$(NAME)

test:
	$(CPL) $(FLAGS_TEST) $(TEST)

clean:
	rm -v $(NAME) 2> /dev/null || true
