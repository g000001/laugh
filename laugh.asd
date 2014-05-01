;;;; laugh.asd -*- Mode: Lisp;-*- 

(cl:in-package :asdf)


(defsystem :laugh
  :serial t
  :depends-on (:fiveam)
  :components ((:file "package")
               (:file "laugh")
               (:file "test")))


(defmethod perform ((o test-op) (c (eql (find-system :laugh))))
  (load-system :laugh)
  (or (flet (($ (pkg sym)
               (intern (symbol-name sym) (find-package pkg))))
        (let ((result (funcall ($ :fiveam :run) ($ :laugh.internal :laugh))))
          (funcall ($ :fiveam :explain!) result)
          (funcall ($ :fiveam :results-status) result)))
      (error "test-op failed") ))


;;; *EOF*
