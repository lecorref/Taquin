(defun read_dimension (in)
  "Function that read the taquin dimension
   @args: fd
   @return: (int)"
  (let ((line (read-line in)))
    (when line
      (if (char= (char line 0) #\#)
	(read_dimension in)
	(parse-integer line)))))

(defun parse_line (line iter)
  "Function that parse the board line
   @args: string int
   @return: (list int)"
  (format t "~d~%" iter)
  (or (> iter 0)
    ()
    (let ((index (position #\Space line)))
      (format t "~d~a~%" index (subseq line 0 index)))))

(defun read_board (iter in)
  "Function that read the taquin board
   @args: int fd
   @return: (list int)"
  (loop for line = (read-line in nil)
    while line do
      (let ((index (position #\# line)))
        (parse_line (subseq line 0 index) iter))))
      
(defun main ()
  (let ((file (open "inputs/solvable_comment_four.npuzzle" :if-does-not-exist nil)))
    (when file
      (let ((lenght (read_dimension file)))
	(format t "~d~%" lenght)
	(read_board lenght file)
      )
      (close file))))

(main)
;(declaim (optimize (speed 3) (safety 0) (space 0)))
;(sb-ext:save-lisp-and-die "npuzzle" :toplevel #'main :executable t)
