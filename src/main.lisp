(defun read_dimension (in)
  "Function that read the taquin dimension
   @args: fd
   @return: (int)"
  (let ((line (read-line in)))
    (when line
      (if (char= (char line 0) #\#)
	(read_dimension in)
	(parse-integer line)))))

(defun parse_line (result line iter)
  "Function that parse the board line
   @args: string int
   @return: (list int)"
  (if (> iter 1)
    (let ((index (position #\Space line)))
      (if (> index 0)
        (parse_line (push (parse-integer (subseq line 0 index)) result) (subseq line index) (- iter 1))
        (parse_line result (subseq line 1) iter)))
    (push (parse-integer line) result)))

(defun read_board (iter in)
  "Function that read the taquin board
   @args: int fd
   @return: (list int)"

  (let ((cells (make-list (* iter iter))))
    (loop for line = (read-line in nil)
      while line do
        (let ((index (position #\# line)))
          (push (parse_line (make-list iter) (subseq line 0 index) iter) cells)))
    cells))

    ;(format t "cells: ~d~%" (parse_line (make-list iter) (subseq line 0 index) iter))
    ;(cons (parse_line (make-list iter) (subseq line 0 index) iter)  cells))

(defun main ()
  (let ((file (open "inputs/solvable_comment_four.npuzzle" :if-does-not-exist nil)))
    (when file
      (let ((lenght (read_dimension file)))
	      (format t "dimension: ~d~%" lenght)
        (format t "cells: ~d~%" (read_board lenght file)))
      (close file))))

(main)
;(declaim (optimize (speed 3) (safety 0) (space 0)))
;(sb-ext:save-lisp-and-die "npuzzle" :toplevel #'main :executable t)
