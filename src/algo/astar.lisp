(defparameter *visited* (make-hash-table :test 'equalp))
(defvar *open-set* '())
(defvar *goal* nil)

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
                 (insert-card-in-list item (cdr sorted-list) function)))))

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
                    (progn
                      (setf (gethash xboard *visited*) b)
                      (setq *open-set*
                            (insert-card-in-list (cons (cons (funcall heuristic x *linear-size*) (+ 1 g))
                                                       x) *open-set* #'compare))))))
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


;(let* (
;       ; (p1 (list-to-puzzle '(4 2 3 1 0 5 7 8 6) 3))
;       ; (p2 (list-to-puzzle '(1 2 3 8 0 4 7 6 5) 3))
;       (p1 (list-to-puzzle '(12 6 8 0 4 10 3 9 14 13 2 15 5 7 1 11) 4))
;       (p2 (list-to-puzzle '(1 2 3 4 12 13 14 5 11 0 15 6 10 9 8 7) 4))
;       )
;  ;  (show-board (p-board p1))
;  ;  (format t "_________________________~%")
;  ;  (show-board (p-board p2))
;  ;  (format t "_________________________~%")
;  (time (init-astar #'manhattan p2 p1))
;  (clrhash *visited*)
;  (time (init-astar #'linear-conflict p2 p1))
;  (clrhash *visited*)
;  (time (init-astar #'misplaced-tiles p2 p1))
;  (clrhash *visited*)
;  (time (init-astar #'n-maxswap p2 p1))
;  (clrhash *visited*)
;  (print (linear-conflict p1 16))
;  (print (misplaced-tiles p1 16))
;  (print (n-maxswap p1 16))
;  (print (n-maxswap p2 16))
;  )
