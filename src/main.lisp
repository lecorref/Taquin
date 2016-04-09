(defun read_dimension (in)
;  (if (char= (char (read-line in) 0) '#'
;    (write-line "is comment!")
;    (write-line "Isn't comment!")))
)

(defun main ()
  (let ((in (open "inputs/solvable_three.npuzzle" :if-does-not-exist nil)))
    (when in
      (read_dimension in)
      (close in)))
)

(declaim (optimize (speed 3) (safety 0) (space 0)))
(sb-ext:save-lisp-and-die "npuzzle" :toplevel #'main :executable t)
