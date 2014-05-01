;;;; package.lisp -*- Mode: Lisp;-*- 

(cl:in-package :cl-user)


(defpackage :laugh
  (:use)
  (:export :laugh :one-laugh))


(defpackage :laugh.internal
  (:use :laugh :cl :named-readtables :fiveam))

