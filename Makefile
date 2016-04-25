CPL := sbcl
NAME := npuzzle
NAME_TEST := npuzzle_test
NAME_BENCH := npuzzle_bench

MAIN := src/main.lisp
TEST := test/main.lisp
BENCH := bench/main.lisp

RTOPT := --dynamic-space-size 3072
RTOPT += --noinform
RTOPT += --disable-ldb
RTOPT += --lose-on-corruption
RTOPT += --end-runtime-options
TLOPT := --noprint
TLOPT += --disable-debugger
TLOPT += --load

RTOPT_TEST := --dynamic-space-size 3072
RTOPT_TEST += --end-runtime-options
TLOPT_TEST := --noprint
TLOPT_TEST += --load

RTOPT_BENCH := --dynamic-space-size 3072
RTOPT_BENCH += --noinform
RTOPT_BENCH += --disable-ldb
RTOPT_BENCH += --lose-on-corruption
RTOPT_BENCH += --end-runtime-options
TLOPT_BENCH := --noprint
TLOPT_BENCH += --disable-debugger
TLOPT_BENCH += --load

ENDOPT := --end-toplevel-options

FLAGS := $(RTOPT) $(TLOPT)
FLAGS_TEST := $(RTOPT_TEST) $(TLOPT_TEST)
FLAGS_BENCH := $(RTOPT_BENCH) $(TLOPT_BENCH)

.PHONY: default build build_test build_bench run run_test run_bench script clean
.SILENT: build build_test build_bench clean

default: build

build: clean
	$(CPL) $(FLAGS) $(MAIN) $(ENDOPT)

build_test:
	$(CPL) $(FLAGS_TEST) $(TEST) $(ENDOPT)

build_bench:
	$(CPL) $(FLAGS_BENCH) $(BENCH) $(ENDOPT)

run: build
	./$(NAME)

run_test: build_test
	./$(NAME_TEST)

run_bench: build_bench
	./$(NAME_BENCH)

script:
	sbcl --script $(MAIN) $(ARGS)

clean:
	rm -v $(NAME) 2> /dev/null || true
	rm -v $(NAME_TEST) 2> /dev/null || true
	rm -v $(NAME_BENCH) 2> /dev/null || true
