(defun add-to-queue (heap item priority)
  (cl-heap:add-to-heap heap (cons priority item)))

(defun pop-queue (heap)
  (cdr (cl-heap:pop-heap heap)))

(defun empty-queue (heap)
  (cl-heap:empty-heap heap))

(defun resart-queue (heap qsize)
  (format t "More than ~r states have been opened and not closed: to save memory, the older have been deleted.
          Please note that could change the result of an uniform cost search~%" qsize)
  (let ((temp-list (loop repeat 10000
                    collect (cl-heap:pop-heap heap))))
    (cl-heap:empty-heap heap)
    (cl-heap:add-all-to-heap heap temp-list))
  (sb-ext:gc :full t))
