(declaim (optimize (compilation-speed 0) (speed 3) (safety 0) (space 3)))
(declaim #+sbcl(sb-ext:muffle-conditions style-warning))
(let ((quicklisp-init (merge-pathnames "~/quicklisp/setup.lisp"
                                       (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))
(with-open-file (*standard-output* "/dev/null" :direction :output
                                   :if-exists :supersede)
  (ql:quickload "cl-heap")
  (ql:quickload "unix-opts"))

(load "src/algo/priority-queue.lisp")
(load "src/algo/solution.lisp")
(load "src/algo/soluble.lisp")
(load "src/algo/puzzle.lisp")
(load "src/algo/astar.lisp")
(load "src/algo/generate.lisp")
(load "src/algo/heuristics.lisp")
(load "src/parser.lisp")
(load "src/lib.lisp")

(defun generate_board (width)
  "Function that parse and test te board with a function
   @args: soluble:enum width:int
   @return: stream"

  (let ((width (write-to-string width))
        (board (make-string-output-stream)))
    (sb-ext:run-program "/usr/bin/python" (list "npuzzle-gen.py" "--solvable" width) :output board)
    (get-output-stream-string board)))

(defun bench_board (width shuffle heuristic cost)
  "Function that runs {passed} tests for solver.
   @args: soluble:enum width:int passed:int
   @return: stream"

   (let ((stream (generate_board width)))
     (with-input-from-string (input stream)
       (let ((width (read_width input)))
         (let ((start_cells (read_board width input))
               (end_cells (solution width)))
            (format t "~d::~d::~s::~s ... bench:~%" width shuffle heuristic cost)
            (time (with-open-file (*standard-output* "/dev/null" :direction :output
                                                                 :if-exists :supersede)
              (generate-and-solve width shuffle heuristic cost 200000 :print)
              )))))))


(defun bench ()
  "Function that is the entry point of bench's program."
  (format t "~%~%running benchmark~%~%")
  (bench_board 3 1000 #'manhattan #'squared)
  (bench_board 3 1000 #'linear-conflict #'squared)
  (bench_board 3 1000 #'misplaced-tiles #'squared)
  (bench_board 3 1000 #'n-maxswap #'squared)
  (bench_board 4 1000 #'manhattan #'squared)
  (bench_board 4 1000 #'linear-conflict #'squared)
  ;(bench_board 4 1000 #'misplaced-tiles #'squared)
  (bench_board 4 1000 #'n-maxswap #'squared)
  ;(bench_board 5 1000 #'manhattan #'squared)
  (bench_board 5 1000 #'linear-conflict #'squared)
  ;(bench_board 5 1000 #'misplaced-tiles #'squared)
  ;(bench_board 5 1000 #'n-maxswap #'squared)
  ;(bench_board 6 1000 #'manhattan #'squared)
  ;(bench_board 6 1000 #'linear-conflict #'squared)
  ;(bench_board 6 1000 #'misplaced-tiles #'squared)
  ;(bench_board 6 1000 #'n-maxswap #'squared)

  (bench_board 3 1000 #'manhattan #'uniform)
  (bench_board 3 1000 #'linear-conflict #'uniform)
  (bench_board 3 1000 #'misplaced-tiles #'uniform)
  (bench_board 3 1000 #'n-maxswap #'uniform)
  ;(bench_board 4 1000 #'manhattan #'uniform)
  ;(bench_board 4 1000 #'linear-conflict #'uniform)
  ;(bench_board 4 1000 #'misplaced-tiles #'uniform)
  ;(bench_board 4 1000 #'n-maxswap #'uniform)
  ;(bench_board 5 1000 #'manhattan #'uniform)
  ;(bench_board 5 1000 #'linear-conflict #'uniform)
  ;(bench_board 5 1000 #'misplaced-tiles #'uniform)
  ;(bench_board 5 1000 #'n-maxswap #'uniform)
  )

(sb-ext:save-lisp-and-die "npuzzle_bench" :toplevel #'bench :executable t)
