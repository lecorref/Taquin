(load "puzzle.lisp")
(defparameter *visited* (make-hash-table :test 'equalp))
(defvar *open-set* '())
(defvar *size* 0)
(defvar *linear-size* 0)
(defvar *goal* nil)
(load "heuristics.lisp")

;print a nice board
(defun show-board (board)
  (loop for i below (car (array-dimensions board)) do
        (loop for j below (cadr (array-dimensions board)) do
              (let ((cell (aref board j i)))
                (format t "~v,'0d " (length (write-to-string *linear-size*)) cell)))
        (format t "~%")))

(defun get-path (board)
  (loop for b = (gethash board *visited*) then (gethash b *visited*)
        until (eql b 'end)
        collect b))

(defun get-next-moves (heuristic p)
  (let ((b (p-board p)))
  (mapc #'(lambda (x)
            (let ((xboard (p-board x)))
            (or (gethash xboard *visited*)
                (progn
                  (setf (gethash xboard *visited*) b)
                  (setq *open-set*
                        (sort (cons (cons (funcall heuristic x *linear-size*) x) *open-set*) #'< :key #'car))))))
        (permutation-list p (- *size* 1)))))


(defun astar (heuristic &optional print-path)
  (loop until (null *open-set*)
        for move from 0
        for tupple = (car *open-set*)
        do (if (= 0 (car tupple))
             (let ((path (get-path (p-board (cdr tupple)))))
              (setq *open-set* nil)
                    (format t "Win with:~T~d moves!~%~T~T~d total opened states~%~T~T~d states tested~%"
                            (length path) (hash-table-count *visited*) move)
                    (if print-path (mapc (lambda (x) (show-board x)(format t "___~%")) path))
                    )
             (progn (setq *open-set* (cdr *open-set*))
                    (get-next-moves heuristic (cdr tupple))))))

(defun init-astar (fn goal start &optional print-path) ;heuristic?
  (setf *goal* goal)
  (setf (gethash (p-board start) *visited*) 'end)
  (setq *open-set* (cons (cons (funcall fn start *linear-size*) start) nil))
  (astar fn print-path)
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

(defun  test (fn p siwe)
  (funcall fn p siwe))

(let* ((p1 (list-to-puzzle '(12 6 8 0 4 10 3 9 14 13 2 15 5 7 1 11) 4))
      (p2 (list-to-puzzle '(1 2 3 4 12 13 14 5 11 0 15 6 10 9 8 7) 4))
      )
  (setf *size* 4)
  (setf *linear-size* 16)
;  (show-board (p-board p1))
;  (format t "_________________________~%")
;  (show-board (p-board p2))
;  (format t "_________________________~%")
  (time (init-astar #'manhattan p2 p1))
  (clrhash *visited*)
  ;(time (init-astar p2 p3 t))
  )
