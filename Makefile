CPL := sbcl
NAME := npuzzle

SRC := src/main.lisp
DEP := src/main.lisp

FLAGS := --script

SRC_TEST := test/lib.lisp
FLAGS_TEST := --script

.PHONY: default build run test clean
.SILENT: build test clean

default: build

build: clean $(NAME)

$(NAME): $(DEP)
	$(CPL) $(FLAGS) $(SRC)

run: build
	./$(NAME)

test:
	$(CPL) $(FLAGS_TEST) $(SRC_TEST)

clean:
	rm -v $(NAME) 2> /dev/null || true
