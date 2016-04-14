(load "src/algo/solution.lisp")
(load "src/algo/soluble.lisp")
(load "src/parser.lisp")

(defun main (argv)
  "Function that resolve the files inputs
   @args: files:string"

  (loop for arg in (subseq argv 1) do
    (let ((file (open arg :if-does-not-exist nil)))
      (when file
        (let ((width (read_width file)))
          (let ((start_cells (read_board width file))
                (end_cells (solution width)))
            (format t "width: ~d~%" width)
            (format t "parsed: ~d~%" start_cells)
            (format t "solvable: ~d~%" (is_solvable start_cells end_cells width))
            (format t "solution: ~d~%" end_cells))
        (close file))))))

(main *posix-argv*)
;(declaim (optimize (speed 3) (safety 0) (space 0)))
;(sb-ext:save-lisp-and-die "npuzzle" :toplevel #'main :executable t)
