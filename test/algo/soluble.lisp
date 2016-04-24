(defun soluble_test_board (soluble start_cells end_cells width)
  "Function that test te board with a function
   @args: start_cells:board end_cells:board width:int
   @return: `NIL` if success or `string` to describe the error"

   (let ((solution (is_solvable start_cells end_cells width)))
     (if (not (eq soluble solution))
       (format nil "must-be/is (~s/~s) for:~%~s~%" soluble solution start_cells)
       nil)))

(defun soluble_parse_and_test_board (stream soluble)
  "Function that parse and test te board with a function
   @args: stream
   @return: `NIL` if success or `string` to describe the error"

  (with-input-from-string (input stream)
    (let ((width (read_width input)))
      (let ((start_cells (read_board width input))
            (end_cells (solution width)))
        (soluble_test_board soluble start_cells end_cells width)))))

(defun test_is_solvable (soluble width passed)
  "Function that runs {passed} tests for solver.
   @args: soluble:enum width:int passed:int
   @return: stream"

  (let ((name (format nil "soluble::is_solvable::~d:~s" width soluble))
        (failed 0))
    (format t "~%~%running ~d tests~%~%" passed)
    (loop for _ from 1 to passed do
      (let ((stream (generate_board soluble width)))
        (let ((why (soluble_parse_and_test_board stream soluble)))
          (if (eq why nil)
            (format t "test ~a ... ok~%" name)
            (progn
              (format t "test ~a ... fail because:~s~%" name why)
              (incf failed))))))
    (if (eq failed 0)
      (format t "test result: ok. ~a passed; 0 failed~%" passed)
      (progn
        (format t "test result: err. ~a passed; ~a failed~%" (- passed failed) failed)
        1))))
