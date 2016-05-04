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

(defun resolve (start_cells end_cells width heuristic cost qsize show filename)
  (if (eq (is_solvable start_cells end_cells width) :solvable)
    (show start_cells end_cells width heuristic cost qsize show)
    (format t "~d isn't solvable~%" filename)))

(defun parse_files_and_resolve (filenames goalfile heuristic cost qsize &optional show)
  (if (eq goalfile nil)
    (loop for filename in filenames do
      (let ((fd (open filename :if-does-not-exist nil)))
        (when fd
          (let ((width (read_width fd)))
            (let ((start_cells (read_board width fd))
                  (end_cells (solution width)))
              (close fd)
              (resolve start_cells end_cells width heuristic cost qsize show filename))))))
    (let ((fd (open goalfile :if-does-not-exist nil)))
      (when fd
        (let ((width_goal (read_width fd)))
          (let ((end_cells (read_board width_goal fd)))
            (close fd)
            (loop for filename in filenames do
              (let ((fd (open filename :if-does-not-exist nil)))
                (when fd
                  (let ((width (read_width fd)))
                    (if (not (eq width_goal width))
                      (format t "!= ~d ~d, width of ~s's board and ~s's board aren't equal~%" width_goal width goalfile filename)
                      (let ((start_cells (read_board width fd)))
                        (close fd)
                        (resolve start_cells end_cells width heuristic cost show filename)))))))))))))
