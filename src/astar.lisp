; temporary file with all the basics function that will be moved later

;struct: bord to get tile with position, x and y to get positions with tiles
(defstruct (puzzle (:conc-name p-))
  board x y)

(defun init-puzzle (size)
  "Function that take a size to initialize the puzzle struct arrays
  @args: int
  @return: puzzle"
  (make-puzzle
    :board (make-array (list size size) :element-type 'integer)
    :x (make-array (* size size) :element-type 'integer)
    :y (make-array (* size size) :element-type 'integer)))

;maybe improve this later?
(defun copy-array (array)
 (let ((dims (array-dimensions array)))
   (adjust-array
    (make-array dims :displaced-to array)
    dims)))

(defun copy-puzzle (p)
  (make-puzzle
    :board (copy-array (p-board p))
    :x (copy-array (p-x p))
    :y (copy-array (p-y p))))

;getters
(defun get-tile (p x y)
  (aref (p-board p) x y))

(defun get-x (p tile)
  (aref (p-x p) tile))

(defun get-y (p tile)
  (aref (p-y p) tile))

;setters
(defun set-tile (p tile x y)
  (setf (aref (p-board p) x y) tile))

(defun set-x (p tile x)
  (setf (aref (p-x p) tile) x))

(defun set-y (p tile y)
  (setf (aref (p-y p) tile) y))

(defun set-coord (p tile x y)
  (set-x p tile x)
  (set-y p tile y))

(defun swap-tiles (p x1 y1 x2 y2)
  (let* ((new (copy-puzzle p))
         (tile (get-tile new x2 y2)))
    (set-tile new 0 x2 y2)
    (set-tile new tile x1 y1)
    (set-coord new 0 x2 y2)
    (set-coord new tile x1 y1)
    (return-from swap-tiles new)))

;test if 2 puzzles are equal
(defun test-eq (p1 p2 size)
  (loop for n below size
        if (not (and (= (get-x p1 n) (get-x p2 n))
                     (= (get-y p1 n) (get-y p2 n))))
        do (return nil)
        finally (return t)))

(defun manhattan (p1 p2 size)
  (loop for n from 1 below size
        and ret = 0 then (+ ret
                            (abs (- (get-x p1 n) (get-x p2 n)))
                            (abs (- (get-y p1 n) (get-y p2 n))))
        finally (return ret)))

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


(let* ((p1 (list-to-puzzle '(0 1 2 3 4 5 6 7 8) 3))
      (p2 (list-to-puzzle '(1 2 3 8 0 4 7 6 5) 3))
      (p3 (swap-tiles p1 0 0 0 1))
      (size (* 3 3)))
  (show-board (p-board p1))
  (format t "_________________________~%")
  (show-board (p-board p2))
  (format t "_________________________~%")
  (show-board (p-board p3))
  (format t "_________________________~%")
  (print (manhattan p1 p2 size))
  (print (manhattan p1 p3 size))
  )
