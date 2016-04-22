(defparameter *visited* (make-hash-table :test 'equalp))
(defvar *open-set* '())
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

(defun insert-card-in-list (item sorted-list function)
  "This function puts an item into its proper place in a sorted list
  @args: item:construct; sorted-list:item list; function: sorting function
  @return: sorted item list"
  (cond ((not sorted-list) 
         (list item))
        ((funcall function item (car sorted-list))
         (cons item sorted-list))
        (t (cons (car sorted-list)
                 (insert-card-in-list item (cdr sorted-list) function))))
  )

(defun compare (item list-item)
  "Compare function for a*"
  (< (+ (* (caar item) (caar item)) (cdar item))
     (+ (* (caar list-item) (caar list-item)) (cdar list-item)))
  )

(defun get-next-moves (g heuristic p)
  (let ((b (p-board p)))
    (mapc #'(lambda (x)
              (let ((xboard (p-board x)))
                (or (gethash xboard *visited*)
                    (let ((h (funcall heuristic x *linear-size*)))
                      (setf (gethash xboard *visited*) b)
                      (and (> *maxe-size* (+ g h))
                           (setq *open-set*
                                 (sort (cons (cons (cons (funcall heuristic x *linear-size*) (+ 1 g))
                                                   x)
                                             *open-set*)
                                       #'compare)
                                 ;       (insert-card-in-list (cons (cons h (+ 1 g))
                                 ;                                  x) *open-set* #'compare)
                                 ))))))
          (permutation-list p (- *size* 1)))))


(defun astar (heuristic &optional print-path)
  (loop until (null *open-set*)
        for move from 0
        for tupple = (car *open-set*)
        do (if (= 0 (caar tupple))
             (let ((path (get-path (p-board (cdr tupple)))))
               (setq *open-set* nil)
               (format t "Win with:~T~d moves!~%~T~T~d total opened states~%~T~T~d states tested~%"
                       (cdar tupple) (hash-table-count *visited*) move)
               (if print-path (mapc (lambda (x) (show-board x)(format t "___~%")) path))
               )
             (progn (setq *open-set* (cdr *open-set*))
                    (get-next-moves (cdar tupple) heuristic (cdr tupple))))))

(defun init-astar (fn goal start &optional print-path) ;heuristic?
  (setf *goal* goal)
  (setf (gethash (p-board start) *visited*) 'end)
  (setq *open-set* (cons (cons (cons (funcall fn start *linear-size*) 0) start) nil))
  (setq *maxe-size* (* *linear-size* *linear-size*) )
  (astar fn print-path)
  )

