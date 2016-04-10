(defun read_dimension (in)
  "Function that read the taquin dimension
   @args: open
   @return: (int)"
  (let ((line (read-line in)))
    (when line
      (if (char= (char line 0) #\#)
	(read_dimension in)
	(parse-integer line)))))

(defun main ()
  (let ((file (open "inputs/solvable_three.npuzzle" :if-does-not-exist nil)))
    (when file
      (format t "~d~%" (read_dimension file))
      (close file))))

(main)
;(declaim (optimize (speed 3) (safety 0) (space 0)))
;(sb-ext:save-lisp-and-die "npuzzle" :toplevel #'main :executable t)
