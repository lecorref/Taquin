(defun solution_set_board (acc width x pos_x y pos_y limit)
  "Function that set the solution board
   @args: acc:(list int) width:int x:int pos_x:int y:int pos_y:int limit:int
   @return: (list int)"

  (if (> (setf (nth (+ x (* y width)) acc) limit) 0)
    (progn
      (if (or (eq (+ x pos_x) width)
              (< (+ x pos_x) 0)
              (and (not (eq pos_x 0))
                   (not (eq (nth (+ x pos_x (* y width)) acc) -1))))
          (progn
            (setq pos_y pos_x)
            (setq pos_x 0))
          (if (or (eq (+ y pos_y) width)
                (< (+ y pos_y) 0)
                (and (not (eq pos_y 0))
                     (not (eq (nth (+ x (* (+ y pos_y) width)) acc) -1))))
          (progn
            (setq pos_x (- pos_y))
            (setq pos_y 0))))

      (let ((inc_limit (+ limit 1)))
        (if (eq inc_limit (* width width))
          (solution_set_board acc width (+ x pos_x) pos_x (+ y pos_y) pos_y 0)
          (solution_set_board acc width (+ x pos_x) pos_x (+ y pos_y) pos_y inc_limit))))
    acc))

(defun solution (width)
  "Function that configure the solution board
   @args: width:int
   @return: (list int)"

  (solution_set_board (make-list (* width width) :initial-element -1)
                       width 0 1 0 0 1))
