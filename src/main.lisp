(defun read_dimension (in)
  "Function that read the taquin dimension
   @args: fd
   @return: (int)"
  (let ((line (read-line in)))
    (when line
      (if (char= (char line 0) #\#)
	(read_dimension in)
	(parse-integer line)))))

(defun read_board (in)
  "Function that read the taquin board
   @args: in
   @return: (list int)"
  (loop for line = (read-line in nil)
    while line do
      (let ((index (position #\# line)))
	(format t "~a~%" (subseq line 0 index)))))

(defun main ()
  (let ((file (open "inputs/solvable_comment_four.npuzzle" :if-does-not-exist nil)))
    (when file
      (format t "~d~%" (read_dimension file))
      (read_board file)
      (close file))))

(main)
;(declaim (optimize (speed 3) (safety 0) (space 0)))
;(sb-ext:save-lisp-and-die "npuzzle" :toplevel #'main :executable t)
