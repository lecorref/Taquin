(declaim (optimize (compilation-speed 0) (speed 3) (safety 0) (space 3)))
(let ((quicklisp-init (merge-pathnames "~/quicklisp/setup.lisp"
                                       (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))
(with-open-file (*standard-output* "/dev/null" :direction :output
                                   :if-exists :supersede)
  (ql:quickload "cl-heap")
  (ql:quickload "unix-opts"))

(load "src/options.lisp")
(load "src/algo/solution.lisp")
(load "src/algo/soluble.lisp")
(load "src/algo/puzzle.lisp")
(load "src/algo/astar.lisp")
(load "src/algo/generate.lisp")
(load "src/algo/heuristics.lisp")
(load "src/parser.lisp")

(defun show (start_cells end_cells width heuristic cost &optional show)
  (setf *size* width)
  (setf *linear-size* (* width width))
  (init-astar heuristic cost (list-to-puzzle start_cells width)
              (list-to-puzzle end_cells width) show))

(defun generate-and-solve (width shuffle heuristic cost &optional show)
  "Generate a random puzzle then solve it
  @args: width:int | &opt: shuffle:int heuristic:function show:bool"
  (setf *size* width)
  (setf *linear-size* (* width width))
  (format t "Generate board...~%")
  (let* ((origin (list-to-puzzle (solution width) width))
         (new (create-random-puzzle origin shuffle)))
    (show-board (p-board new))
    (init-astar heuristic cost new origin show)))

(defun parse_files (filenames heuristic cost &optional show)
  (loop for filename in filenames do
        (let ((fd (open filename :if-does-not-exist nil)))
          (when fd
            (let ((width (read_width fd)))
              (let ((start_cells (read_board width fd))
                    (end_cells (solution width)))
                (if (eq (is_solvable start_cells end_cells width) :solvable)
                  (show start_cells end_cells width heuristic cost show)
                  (format t "~d isn't solvable~%" filename)))
              (close fd))))))

(defun main ()
  (multiple-value-bind (options free-args)
    (handler-case
      (handler-bind ((opts:unknown-option #'unknown-option))
        (opts:get-opts))
      (opts:missing-arg (condition)
                        (format t "fatal: option ~s needs an argument!~%"
                                (opts:option condition)))
      (opts:arg-parser-failed (condition)
                              (format t "fatal: cannot parse ~s as argument of ~s~%"
                                      (opts:raw-arg condition)
                                      (opts:option condition)))
      )
    (when-option (options :help)
                 (opts:describe
                   :prefix "Npuzzle solver"
                   :suffix "heuristics: manhattan; linear-conflict, misplaced-tiles, n-maxswap"
                   :usage-of "npuzzle"
                   :args     "[FREE-ARGS]") (return-from main nil))
    (when-option (options :generate)
                 (generate-and-solve it (get-options (options :randomize) 1000)
                                     (get-options (options :heuristic) #'linear-conflict)
                                     (get-options (options :cost) #'squared)
                                     (getf options :show)))
    (when-option (options :load)
                 (parse_files it (get-options (options :heuristic) #'linear-conflict)
                              (get-options (options :cost) #'squared)
                              (getf options :show)))
    )
  )

(sb-ext:save-lisp-and-die "npuzzle" :toplevel #'main :executable t)
