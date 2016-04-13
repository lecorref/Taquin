(load "puzzle.lisp")
(defparameter *visited* (make-hash-table :test 'equalp))
(defparameter *came-from* (make-hash-table :test 'equalp))
(defvar *open-set* '())
(defvar *closed-set* '())
(defvar *goal* nil)

(defun manhattan (p size)
  (loop for n from 1 below size
        and ret = 0 then (+ ret
                            (abs (- (get-x p n) (get-x *goal* n)))
                            (abs (- (get-y p n) (get-y *goal* n))))
        finally (return ret)))

;print a nice board
(defun show-board (board)
  (loop for i below (car (array-dimensions board)) do
        (loop for j below (cadr (array-dimensions board)) do
              (let ((cell (aref board j i)))
                (format t "~a " cell)))
        (format t "~%")))

(defun get-path (board)
  (loop for b = (gethash board *visited*) then (gethash b *visited*)
        until (eql b 'end)
        collect b))

(defun get-next-moves (p size)
  (let ((b (p-board p)))
  (mapc #'(lambda (x)
            (let ((xboard (p-board x)))
            (or (gethash xboard *visited*)
                (progn
                  (setf (gethash xboard *visited*) b)
                  (setq *open-set*
                        (sort (cons (cons (manhattan x (* size size)) x) *open-set*) #'< :key #'car))))))
        (permutation-list p (- size 1)))))


(defun astar (size)
  (loop until (null *open-set*)
        for move from 0
        for tupple = (car *open-set*)
        do (if (= 0 (car tupple))
             (progn (setq *open-set* nil)
                    (format t "Win with:~T~d moves!~%~T~T~d total opened states~%~T~T~d states tested~%"
                            (length (get-path (p-board (cdr tupple)))) (hash-table-count *visited*) move))
             (progn (setq *open-set* (cdr *open-set*))
                    (get-next-moves (cdr tupple) size)))))

;recursive looping test
;(defun astar2 (size moves)
;  (if (null *open-set*)
;    (progn (format t "insolvable~%") (return-from astar nil)))
;  (let ((tupple (car *open-set*)))
;    (if (= 0 (car tupple))
;      (format t "Win with:~T~d moves tested!~%~T~T~d total opened states" moves (hash-table-count *visited*))
;      (progn
;        (setq *open-set* (cdr *open-set*))
;        (get-next-moves (cdr tupple) size)
;        (astar2 size (+ 1 moves))))))
;
;(defun init-astar2 (goal start size) ;heuristic?
;  (setf *goal* goal)
;  (setf (gethash (p-board start) *visited*) 'end)
;  (setq *open-set* (cons (cons (manhattan start (* size size)) start) nil))
;  (astar2 size 0)
;  )

(defun init-astar (goal start size) ;heuristic?
  (setf *goal* goal)
  (setf (gethash (p-board start) *visited*) 'end)
  (setq *open-set* (cons (cons (manhattan start (* size size)) start) nil))
  (astar size)
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


(let* ((p1 (list-to-puzzle '(12 6 8 0 4 10 3 9 14 13 2 15 5 7 1 11) 4))
      (p2 (list-to-puzzle '(1 2 3 4 12 13 14 5 11 0 15 6 10 9 8 7) 4))
      (p3 (copy-puzzle p1))
      )
  (show-board (p-board p1))
  (format t "_________________________~%")
  (show-board (p-board p2))
  (format t "_________________________~%")
  (time (init-astar p2 p1 4))
  ;(clrhash *visited*)
  ;(time (init-astar2 p2 p3 4))
  )
