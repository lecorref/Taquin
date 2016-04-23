;do not take any function as parameter
(defun str-function (str)
  (let ((func (find-symbol (string-upcase str))))
    (if func func (error "~s not a valid function" str))))

(opts:define-opts
  (:name :help
    :description "Print usage"
    :short #\h
    :long "help")
  (:name :load
    :description "Parse the puzzle from file"
    :short #\l
    :long "load"
    :arg-parser #'list
    :meta-var "FILE")
  (:name :generate
    :description "Parse the puzzle from file"
    :short #\g
    :long "generate"
    :arg-parser #'parse-integer
    :meta-var "SIZE")
  (:name :show
    :description "Print each passed states"
    :short #\s
    :long "show")
  (:name :randomize
    :description "Use with generate. print each passed states"
    :short #\r
    :long "randomize"
    :arg-parser #'parse-integer
    :meta-var "MOVES")
  (:name :heuristic
    :description "The program will use the provided heuristic function (default linear-conflict)"
    :short #\e
    :long "heuristic"
    :arg-parser #'str-function
    :meta-var "FUNCTION")
  )

(defun unknown-option (condition)
  (format t "warning: ~s option is unknown!~%" (opts:option condition))
  (invoke-restart 'opts:skip-option))

(defmacro when-option ((options opt) &body body)
  `(let ((it (getf ,options ,opt)))
     (when it
       ,@body)))

(defmacro get-options ((options opt) value)
  `(let ((it (getf ,options ,opt)))
     (if it it ,value)))
