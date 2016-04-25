(load "src/algo/solution.lisp")
(load "src/algo/soluble.lisp")
(load "src/parser.lisp")
(load "src/algo/solution.lisp")
(load "src/algo/soluble.lisp")

(defun generate_board (soluble width)
  "Function that parse and test te board with a function
   @args: soluble:enum width:int
   @return: stream"

  (let ((width (write-to-string width))
        (board (make-string-output-stream)))
    (if (eq soluble :solvable)
      (sb-ext:run-program "/usr/bin/python" (list "npuzzle-gen.py" "--solvable" width) :output board)
      (sb-ext:run-program "/usr/bin/python" (list "npuzzle-gen.py" "--unsolvable" width) :output board))
    (get-output-stream-string board)))

(load "test/algo/soluble.lisp")

(defun test ()
  "Function that is the entry point of test's program."

  (let ((failed 0))
    (loop for passed in (list (test_is_solvable :solvable 3 50)
                              (test_is_solvable :solvable 4 50)
                              (test_is_solvable :solvable 5 50)
                              (test_is_solvable :solvable 6 50)
                              (test_is_solvable :unsolvable 3 50)
                              (test_is_solvable :unsolvable 4 50)
                              (test_is_solvable :unsolvable 5 50)
                              (test_is_solvable :unsolvable 6 50)) do
      (if (not (eq passed nil))
        (incf failed)))
    (if (> failed 0)
      (sb-ext:exit :code 1))))

(sb-ext:save-lisp-and-die "npuzzle_test" :toplevel #'test :executable t)
