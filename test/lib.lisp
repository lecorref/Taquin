(load "src/algo/solution.lisp")
(load "src/algo/soluble.lisp")

(defun check (a b)
  "Function that check if: (eq a b)
   @args: a:list b:list
   @return: (boolean)"

  (if (equal a b)
    1
    0))

(defun checks (tests)
  "Function that checks the multi test and panic if there is a error
   @args: (list (name:string check))
   @return: (boolean)"

  (let ((passed (/ (length tests) 2))
        (failed 0))
    (format t "running ~d tests~%" passed)
    (loop for name in tests by #'cddr
          for result in (cdr tests) by #'cddr do
      (if (eq result 1)
        (format t "test ~a ... ok~%" name)
        (progn
          (format t "test ~a ... fail~%" name)
          (incf failed))))
    (if (eq failed 0)
      (format t "test result: ok. ~a passed; 0 failed~%" passed)
      (progn
        (format t "test result: err. ~a passed; ~a failed~%" (- passed failed)
                                                                failed)
        (sb-ext:exit :code 1)))))

(checks (list "soluble::is_solvable::three" (check
              (is_solvable (list 3 8 4
                                 7 0 1
                                 2 6 5)
                           (list 3 8 4
                                 7 0 1
                                 2 6 5) 3) 1)
              "unsoluble::is_solvable::three" (check (is_solvable
              (list 0 5 2
                    4 7 8
                    3 1 6)
              (list 3 8 4
                    7 0 1
                    2 6 5) 3) 0)
              "solution::three" (check
              (solution 3) (list 1 2 3
                                 8 0 4
                                 7 6 5))
              "solution::four" (check
              (solution 4) (list  1  2  3 4
                                 12 13 14 5
                                 11  0 15 6
                                 10  9  8 7))
              "solution::five" (check
              (solution 5) (list  1  2  3  4 5
                                 16 17 18 19 6
                                 15 24  0 20 7
                                 14 23 22 21 8
                                 13 12 11 10 9))))
