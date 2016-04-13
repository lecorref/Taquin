(defun count_inversion (acc cells)
  "Function that count the number of inversion noted: a > b
   @args: accumulator:int cells:list
   @return: (boolean)"

   (if (> (length cells) 0)
     (let ((a (pop cells)))
       (loop for b in cells do
         (if (and (> a b) (> b 0))
           (incf acc)))
      (count_inversion acc cells))
      acc))

(defun is_solvable (cells width)
  "Function that determine if the board is resolvable
   @args: cells:list width:int
   @return: (boolean)"

   (let ((inversion (count_inversion 0 cells)))
     (if (or (and (eq (mod width 2) 0)
                  (eq (mod inversion 2) 1))
             (and (eq (mod width 2) 1)
                  (eq (eq (mod inversion 2) 0)
                      (nth (+ (- (/ width 2) 1)
                              (* (- (/ width 2) 1) width)) cells))))
       1
       0)))

(defun read_width (in)
  "Function that read the taquin's width
   @args: fd
   @return: (int)"

  (let ((line (read-line in)))
    (when line
      (if (char= (char line 0) #\#)
      	(read_width in)
      	(parse-integer line)))))

(defun parse_line (acc line iter)
  "Function that parse the board line
   @args: line:string width:int
   @return: (list int)"

  (if (> iter 1)
    (let ((index (position #\Space line)))
      (if (> index 0)
        (parse_line (push (parse-integer (subseq line 0 index)) acc)
                    (subseq line index)
                    (- iter 1))
        (parse_line acc (subseq line 1) iter)))
    (push (parse-integer line) acc)))

(defun read_board (iter in)
  "Function that read the taquin board
   @args: width:int fd
   @return: (list int)"

  (let ((cells (list)))
    (loop for line = (read-line in nil)
      while line do
        (let ((index (position #\# line)))
          (setq cells
            (append cells
              (reverse (parse_line (list) (subseq line 0 index) iter))))))
    cells))

(defun main (argv)
  "Function that resolve the files inputs
   @args: files:string"

  (loop for arg in (subseq argv 1) do
    (let ((file (open arg :if-does-not-exist nil)))
      (when file
        (let ((width (read_width file)))
          (format t "width: ~d~%" width)
          (let ((cells (read_board width file)))
            (format t "cells: ~d~%" cells)
            (format t "solvable: ~d~%" (is_solvable cells width)))
        (close file))))))

(main *posix-argv*)
;(declaim (optimize (speed 3) (safety 0) (space 0)))
;(sb-ext:save-lisp-and-die "npuzzle" :toplevel #'main :executable t)
