(deftype soluble () '(member solvable unsolvable))

(defun soluble_inversion (acc cells)
  "Function that count the number of inversion noted: a > b
   @args: acc:int cells:list
   @return: (boolean)"

  (if (> (length cells) 0)
    (let ((a (pop cells)))
      (loop for b in cells do
        (if (and (> a b) (> b 0))
          (incf acc)))
     (soluble_inversion acc cells))
     acc))


(defun soluble_index_pos (acc index cells)
  "Function that found the position of index
   @args: acc:int index:int cells:list
   @return: (int)"

  (if (and (> (length cells) 0) (not (eq (pop cells) index)))
    (soluble_index_pos (+ acc 1) index cells)
    acc))

(defun soluble_solve! (start_inversion end_inversion)
  "Function that check if the board is resolvable
   @args: start_cells:list end_cells:list
   @return: (boolean)"

  (if (eq (mod start_inversion 2) (mod end_inversion 2))
      :solvable
      :unsolvable))

(defun is_solvable (start_cells end_cells width)
  "Function that determine if the board is resolvable
   @args: start_cells:list end_cells:list width:int
   @return: (boolean)"

  (let ((start_inversion (soluble_inversion 0 start_cells))
        (end_inversion (soluble_inversion 0 end_cells)))
    (if (eq (mod width 2) 0)
      (soluble_solve! (+ start_inversion
                        (floor (/ (soluble_index_pos 0 0 start_cells) width)))
                      (+ end_inversion
                        (floor (/ (soluble_index_pos 0 0 end_cells) width))))
      (soluble_solve! start_inversion end_inversion))))
