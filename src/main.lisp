(load "src/algo/solution.lisp")
(load "src/algo/soluble.lisp")
(load "src/algo/puzzle.lisp")
(load "src/algo/astar.lisp")
(load "src/parser.lisp")

(defun resolve (start_cells end_cells width)
  (let* ((p1 (list-to-puzzle start_cells width))
         (p2 (list-to-puzzle end_cells width)))
    (setf *size* width)
    (setf *linear-size* (* width))
    (show-board (p-board p1))
    (format t "_________________________~%")
    (show-board (p-board p2))
    (format t "_________________________~%")
;    (time (init-astar #'manhattan p2 p1))
    (clrhash *visited*)))

(defun main (argv)
  "Function that resolve the files inputs
   @args: files:string"

  (loop for filename in (subseq argv 1) do
    (let ((fd (open filename :if-does-not-exist nil)))
      (when fd
        (let ((width (read_width fd)))
          (let ((start_cells (read_board width fd))
                (end_cells (solution width)))
            (if (eq (is_solvable start_cells end_cells width) 1)
              (resolve start_cells end_cells width)
              (format t "~d isn't solvable~%" filename)))
        (close fd))))))

(main *posix-argv*)
;(declaim (optimize (speed 3) (safety 0) (space 0)))
;(sb-ext:save-lisp-and-die "npuzzle" :toplevel #'main :executable t)
