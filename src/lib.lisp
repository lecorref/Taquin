(defun show (start_cells end_cells width heuristic cost qsize &optional show)
  (setf *size* width)
  (setf *linear-size* (* width width))
  (init-astar heuristic cost (list-to-puzzle start_cells width)
              (list-to-puzzle end_cells width) qsize show))

(defun generate-and-solve (width shuffle heuristic cost qsize &optional show)
  "Generate a random puzzle then solve it
  @args: width:int | &opt: shuffle:int heuristic:function show:bool"
  (setf *size* width)
  (setf *linear-size* (* width width))
  (format t "Generate board...~%")
  (let* ((origin (list-to-puzzle (solution width) width))
         (new (create-random-puzzle origin shuffle)))
    (show-board (p-board new))
    (init-astar heuristic cost new origin qsize show)))
