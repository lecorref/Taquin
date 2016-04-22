(defun get-random-next-state (p rstate)
  (let ((new (permutation-list p (- *size* 1))))
    (nth (random (length new) rstate) new)))

(defun create-random-puzzle (origin num)
  (let ((rand (make-random-state t)))
    (loop repeat num
          for puzzle = origin then (get-random-next-state puzzle rand)
          finally (return puzzle))
    )
  )
