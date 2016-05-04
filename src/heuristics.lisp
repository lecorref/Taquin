(defvar *size* 0)

(defun manhattan (p size)
  (loop for n from 1 below size
        and ret = 0 then (+ ret
                            (abs (- (get-x p n) (get-x *goal* n)))
                            (abs (- (get-y p n) (get-y *goal* n))))
        finally (return ret)))


(defun linear-conflict (p size)
  (let ((man (manhattan p size)))
    (print (loop for n from 1 below size
                 for retx = (make-array *size* :element-type 'integer)
                 for rety = (make-array *size* :element-type 'integer)
          for px = (get-x p n)
          for py = (get-y p n)
          for x = (- px (get-x *goal* n))
          for y = (- py (get-y *goal* n))
          if (and (= x 0) (not (= y 0)))
            do (cons (aref (retx) px) (cons y py))
            ;collect (list px y py) into rety
          if (and (= y 0) (not (= x 0)))
            do (cons (aref (rety) py) (cons x px))
            ;collect (list py x px) into retx
            finally (return (list retx rety))
            ))))
