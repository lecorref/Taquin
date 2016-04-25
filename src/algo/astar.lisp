(defparameter *visited* (make-hash-table :test 'equalp))
(defparameter *open-set* (make-instance 'cl-heap:priority-queue))
;(defvar *open-set* '())
(defvar *goal* nil)
(defvar *maxe-size* 0)

(defun show-board (board)
  "Print board in an ordered way, with padding."
  (loop for i below *size* do
        (loop for j below *size* do
              (let ((cell (aref board (+ j (* *size* i)))))
                (format t "~v,'0d " (length (write-to-string *linear-size*)) cell)))
        (format t "~%")))

(defun get-path (board)
  (loop for b = (gethash board *visited*) then (gethash b *visited*)
        until (eql b 'end)
        collect b))

(defun uniform (h g)
  (+ h g))

(defun squared (h g)
  (+ (* h h) g))

(defun greedy (h g)
  h)

(defun get-next-moves (g heuristic cost p)
  (let ((b (p-board p)))
    (mapc #'(lambda (x)
              (let ((xboard (p-board x)))
                (or (gethash xboard *visited*)
                    (let ((h (funcall heuristic x *linear-size*)))
                      (setf (gethash xboard *visited*) b)
                      (and (> *maxe-size* (+ g h))
                           (cl-heap:enqueue *open-set*
                                 (cons (cons h (+ 1 g)) x) (funcall cost h g)))))))
          (permutation-list p (- *size* 1)))))


(defun astar (heuristic cost &optional print-path)
  (loop until (= 0 (cl-heap:queue-size *open-set*))
        for move from 0
        for tupple = (cl-heap:dequeue *open-set*)
        do (if (= 0 (caar tupple))
             (let ((path (get-path (p-board (cdr tupple)))))
               (cl-heap:empty-queue *open-set*)
               (format t "Win with:~T~d moves!~%~T~T~d total opened states~%~T~T~d states tested~%"
                       (cdar tupple) (hash-table-count *visited*) move)
               (if print-path (mapc (lambda (x) (show-board x)(format t "___~%")) path))
               )
             (get-next-moves (cdar tupple) heuristic cost (cdr tupple)))))


(defun init-astar (fn cost goal start &optional print-path) ;heuristic?
  (setf *goal* goal)
  (setf (gethash (p-board start) *visited*) 'end)
  (let ((priority (funcall fn start *linear-size*)))
    (cl-heap:enqueue *open-set* (cons (cons priority 0) start) priority)
    )
  (setq *maxe-size* (/ (* *linear-size* *linear-size*) 2))
  )
