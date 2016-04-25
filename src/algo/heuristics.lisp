(defvar *size* 0)

(declaim (inline manhattan))
(defun manhattan (p size)
  (loop for n from 1 below size
        sum (+ (abs (- (get-x p n) (get-x *goal* n)))
               (abs (- (get-y p n) (get-y *goal* n))))))

(declaim (inline conflicts))
(defun conflicts (tab)
  (loop for x across tab
        unless (or (null x) (= 1 (length x)))
        sum (labels ((comp (fst rst)
                           (cond
                             ((= 1 (length fst)) 0)
                             ((null rst) (comp (cdr fst) (cddr fst)))
                             ((< (- (cdar rst) (cdar fst)) (- (caar fst) (caar rst)))
                              (+ 2 (comp fst (cdr rst))))
                             (t (comp fst (cdr rst))))
                           ))
              (comp x (cdr x)))))

(defun linear-conflict (p size)
  (let ((retx (make-array *size* :initial-element nil))
        (rety (make-array *size* :initial-element nil)))
    (loop for n from 1 below size
          for px = (get-x p n)
          for py = (get-y p n)
          for x = (- (get-x *goal* n) px)
          for y = (- (get-y *goal* n) py)
          sum (+ (abs x) (abs y)) into manhattan
          if (and (= x 0) (not (= y 0)))
            do (setf (aref rety px) (cons (cons y py) (aref rety px)))
          if (and (= y 0) (not (= x 0)))
            do (setf (aref retx py) (cons (cons x px) (aref retx py)))
          finally (return (+ manhattan (conflicts rety)
                             (conflicts retx))))))

(declaim (inline misplaced-tiles))
(defun misplaced-tiles (p size)
  (loop for n below size
        unless (and (= (get-x p n) (get-x *goal* n))
                    (= (get-y p n) (get-y *goal* n)))
        sum 1))

(defun n-maxswap (p size)
  (let ((puzzle (copy-puzzle p)))
    (loop for x0 = (get-x puzzle 0)
          for y0 = (get-y puzzle 0)
          until (and (= x0 (get-x *goal* 0))
                      (= y0 (get-y *goal* 0)))
          for n = (get-tile *goal* x0 y0)
          for x1 = (get-x puzzle n)
          for y1 = (get-y puzzle n)
          do (progn
               (set-tile puzzle 0 x1 y1)
               (set-tile puzzle n x0 y0)
               (set-coord puzzle 0 x1 y1)
               (set-coord puzzle n x0 y0)
               )
          sum 1 into ret
          finally (return (+ ret (misplaced-tiles puzzle size))))))
