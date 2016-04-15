(load "src/algo/solution.lisp")
(load "src/algo/soluble.lisp")
(load "src/algo/puzzle.lisp")
(load "src/algo/astar.lisp")
(load "src/algo/heuristics.lisp")
(load "src/parser.lisp")

(defun show (start_cells end_cells width &optional show)
    (setf *size* width)
    (setf *linear-size* (* width width))
    (init-astar #'manhattan (list-to-puzzle start_cells width)
                            (list-to-puzzle end_cells width) show))

(defun parse_files (filenames &optional show)
  (loop for filename in filenames do
    (let ((fd (open filename :if-does-not-exist nil)))
      (when fd
        (let ((width (read_width fd)))
          (let ((start_cells (read_board width fd))
                (end_cells (solution width)))
            (if (eq (is_solvable start_cells end_cells width) 1)
              (show start_cells end_cells width show)
              (format t "~d isn't solvable~%" filename)))
        (close fd))))))

(defun main (argv)
  "Function that resolve the files inputs
   @args: files:string"

  (if (or (string= (nth 1 argv) "--show")
          (string= (nth 1 argv) "-s"))
    (parse_files (subseq argv 2) t))
    (parse_files (subseq argv 1)))

(main *posix-argv*)
;(declaim (optimize (speed 3) (safety 0) (space 0)))
;(sb-ext:save-lisp-and-die "npuzzle" :toplevel #'main :executable t)
