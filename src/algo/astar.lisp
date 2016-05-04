(defvar *goal* nil)
(defvar *maxe-size* 0)

(defun set-counter ()
  "basic counter function
   @args: nil
   @return: (function -> nil function -> nil function -> int)"
  (let ((count 0))
    (cons
     (lambda () (incf count))
     (lambda () count))))

(defun show-board (board)
  "Print board in an ordered way, with padding."
  (loop for i below *size* do
        (loop for j below *size* do
              (let ((cell (aref board (+ j (* *size* i)))))
                (format t "~v,'0d " (length (write-to-string *linear-size*)) cell)))
        (format t "~%")))

(defun get-path (visited board)
  (loop for b = (gethash board visited) then (gethash b visited)
        until (eql b 'end)
        collect b))

(declaim (inline uniform))
(defun uniform (h g)
  (+ h g))

(declaim (inline squared))
(defun squared (h g)
  (+ (* h h) g))

(declaim (inline greedy))
(defun greedy (h g)
  h)

(defun get-next-moves (open-set visited g heuristic cost puzzle qsize counter)
  (let ((b (p-board (car puzzle)))
        (old (cdr puzzle)))
        (setf (gethash b visited) old)
        (and (> (cl-heap:heap-size open-set) qsize) (resart-queue open-set qsize))
        (mapc #'(lambda (x)
                  (let ((xboard (p-board x)))
                    (or (gethash xboard visited)
                        (let ((h (funcall heuristic x *linear-size*)))
                          (and (> *maxe-size* (+ g h))
                               (progn (funcall (car counter))
                               (add-to-queue open-set
                                             (cons (cons h (+ 1 g)) (cons x b))
                                             (funcall cost h g))))))))
              (permutation-list (car puzzle) (- *size* 1)))))


(defun astar (open-set visited heuristic cost qsize &optional print-path)
  (let ((counter (set-counter)))
  (loop until (cl-heap:is-empty-heap-p open-set)
        for move from 0
        for tupple = (pop-queue open-set)
        for max_size = 0 then (max max_size (cl-heap:heap-size open-set))
        do (if (= 0 (caar tupple))
             (progn
               (empty-queue open-set)
               (format t "Win with:~T~d moves!~%~T~T~d complexity in size~%~T~T~d complexity in time~%"
                       (cdar tupple) max_size (funcall (cdr counter)))
               (if print-path (mapc (lambda (x) (show-board x)(format t "___~%"))
                                    (get-path visited (cddr tupple)))))
             (get-next-moves open-set visited (cdar tupple) heuristic cost (cdr tupple) qsize counter)))))


(defun init-astar (fn cost goal start qsize &optional print-path) ;heuristic?
  (setf *goal* goal)
  (setq *maxe-size* (* *size* *size* *size* 3))
  (let ((visited (make-hash-table :test 'equalp))
        (priority (funcall fn start *linear-size*))
        (open-set (make-instance 'cl-heap:fibonacci-heap :key #'car :sort-fun #'<)))
    (add-to-queue open-set (cons (cons priority 0) (cons start 'end)) priority)
    (astar open-set visited fn cost qsize print-path)))
