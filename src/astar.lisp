(load "puzzle.lisp")
(defparameter *visited* (make-hash-table))
(defparameter *came-from* (make-hash-table))
(defvar *open-set* '())
(defvar *closed-set* '())
(defvar *goal* nil)

(defun manhattan (p size)
  (loop for n from 1 below size
        and ret = 0 then (+ ret
                            (abs (- (get-x p n) (get-x *goal* n)))
                            (abs (- (get-y p n) (get-y *goal* n))))
        finally (return ret)))

(defun get-next-moves (p size)
  (mapc #'(lambda (x)
            (or (gethash x *visited*)
                (progn
                  (setf (gethash x *visited*) x)
                  (setf (gethash x *came-from*) p)
                  (setq *open-set* (cons (cons (manhattan x (* size size)) x) *open-set*)))))
        (permutation-list p (- size 1))))

;resolution: maybe set the heuristic later, in a closure, and maybe a print opt?
;(defun a-star (puzzle goal size)
;  (let ((linear-size (* size size)) (border (- size 1)))
;    (loop
;
;      do (progn (show-board (p-board p))
;               (format t "_________________________~%"))
;      until (test-eq puzzle goal linear-size)
;      )
;    )
;  )

;make a structure form a list
(defun list-to-puzzle (lst size)
  (let ((puzzle (init-puzzle size)))
    (loop for i below size do
          (loop for j below size do
                (let ((n (+ i (* j size))))
                  (set-tile puzzle (nth n lst) i j)
                  (set-coord puzzle (nth n lst) i j))))
    puzzle))

;print a nice board
(defun show-board (board)
  (loop for i below (car (array-dimensions board)) do
        (loop for j below (cadr (array-dimensions board)) do
              (let ((cell (aref board j i)))
                (format t "~a " cell)))
        (format t "~%")))


(let* ((p1 (list-to-puzzle '(1 2 3 8 4 7 6 5 0) 3))
      (p2 (list-to-puzzle '(1 2 3 8 0 4 7 6 5) 3)))
  (setf *goal* p2)
  (setf (gethash p1 *visited*) p1)
  (setf (gethash p2 *visited*) p2)
  (print (gethash p1 *visited*))
  (print (gethash p2 *visited*))
  (get-next-moves p1 3)
  (mapcar #'(lambda (x) (print x)) *open-set*)
;    (show-board (p-board p1))
;    (format t "_________________________~%")
;    (show-board (p-board p2))
  )
