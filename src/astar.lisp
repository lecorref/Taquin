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

(defun get-next-moves (p size oset)
  (mapc #'(lambda (x)
            (or (gethash x *visited*)
                (progn
                  (setf (gethash x *visited*) x)
                  (setf (gethash x *came-from*) p)
                  (setq *open-set*
                        (sort (cons (cons (manhattan x (* size size)) x) oset) #'< :key #'car)))))
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

;(defun astar (size)
;  (loop until (null *open-set*)
;        for move from 0
;        for tupple = (car *open-set*)
;        do (if (= 0 (car tupple))
;             (progn (setq *open-set* nil)
;               (format t "Win in ~d moves!~%" move))
;             (get-next-moves (cdr tupple) size (cdr *open-set*)))))

;recursive looping test
(defun astar (size moves)
  (if (null *open-set*)
    (progn (format t "insolvable~%") (return-from astar nil)))
  (let ((tupple (car *open-set*)))
    (if (= 0 (car tupple))
      (format t "Win in ~d moves!~%" moves)
      (progn
        (setq *open-set* (cdr *open-set*))
        (get-next-moves (cdr tupple) size (cdr *open-set*))
        (astar size (+ 1 moves))))))

(defun init-astar (goal start size) ;heuristic?
  (setf *goal* goal)
  (setf (gethash start *visited*) start)
  (setq *open-set* (cons (cons (manhattan start (* size size)) start) nil))
  (astar size 0)
  )

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


(let* ((p1 (list-to-puzzle '(1 2 3 8 0 4 7 6 5) 3))
      (p2 (list-to-puzzle '(1 2 3 8 4 0 7 6 5) 3)))
  (init-astar p2 p1 3)
;    (show-board (p-board p1))
;    (format t "_________________________~%")
;    (show-board (p-board p2))
  )
