(defun parser_parse_line (acc line iter)
  "Function that parse the board line
   @args: line:string width:int
   @return: (list int)"

  (if (> iter 1)
    (let ((index (position #\Space line)))
      (if (> index 0)
        (parser_parse_line (push (parse-integer (subseq line 0 index)) acc)
                    (subseq line index)
                    (- iter 1))
        (parser_parse_line acc (subseq line 1) iter)))
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
              (reverse (parser_parse_line (list) (subseq line 0 index) iter))))))
    cells))

(defun read_width (in)
  "Function that read the taquin's width
   @args: fd
   @return: (int)"

  (let ((line (read-line in)))
    (when line
      (if (char= (char line 0) #\#)
      	(read_width in)
      	(parse-integer line)))))
