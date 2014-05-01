;	Fri|ASept 8,1978  22:14  NM+6D.17H.53M.39S.  -*- Lisp -*-
;	Thu|May 1,2014 22:07 JST  NM+2D.7H.11M.52S. Ported to CL by mc

(cl:in-package :laugh.internal)


(let* ((l '("Ha Ha" "Snort" "Chortle" "Ha" "He" "He He" "He He He" "Chortle"
           "Ho" "Ho Ho" "Ho Ho Ho" "Snicker" "Ha Ha Ha" "Giggle" "Chuckle"
           "Guffaw"))
       (laughs (make-array (length l) :initial-contents l)))
  (defun laughs (pos) (aref laughs pos))
  (declaim (fixnum *laughs-dimension))
  (defvar *laughs-dimension (length l)))


(defvar *line-width 80)


(defun linel (file &optional size)
  (declare (ignore file))
  ;;--- TODO
  (when size (setq *line-width size))
  *line-width)


(defun +tyo (code stream)
  (declare ((integer 0 *) code))
  (princ (code-char code) stream))


(defun charpos (stream)
  #+:sbcl
  (let ((stream (sb-impl::out-synonym-of stream)))
    (if (sb-impl::ansi-stream-p stream)
        (sb-kernel:charpos stream)
        (sb-gray:stream-line-column stream)))
  #-:sbcl 0                              ;--- TODO
  )


(defun one-laugh1 (phrase output-file)
   (or (and (eq output-file t) 
            (setq output-file *standard-output*))
       ((lambda (pos)
	   (declare (fixnum pos))
	   (cond ((> (+ (length phrase) 1 pos) (linel output-file))
		    (terpri output-file))
		 ((not (= pos 0)) (princ #\Space output-file)))
	   (and (eq output-file *standard-output*) (+tyo 7. output-file))
	   (princ phrase output-file)
           (force-output output-file))
	(charpos output-file))))


(defun one-laugh2 (phrase list) 
    (mapc (lambda (f) (one-laugh1 phrase f)) list)
    t)


(defun one-laugh (output-file)
  ((lambda (phrase)
       (cond ((null output-file)
		(one-laugh1 phrase t))
	     ((atom output-file) (one-laugh1 phrase output-file))
	     (t (one-laugh2 phrase output-file))))
   (laughs (random *laughs-dimension))))


(defun filep (stream)
  (typep stream 'file-stream))


(defun laugh (arg output-filespec)
  (prog ((i 0) no-sleep-p)
     (declare (fixnum i))
     (setq no-sleep-p (or (filep output-filespec)
                          (typep output-filespec 'string-stream)))
  error-return-loop
     (cond ((null arg) (setq i 1))
	   ((eq arg 'uncontrollably) (setq i #.(ash 1 34.)))
	   ((typep arg 'fixnum) (setq i arg))
	   (t (error "~A: Bad arg - LAUGH arg: ~A" 'wrng-type-arg arg)))
     (terpri output-filespec)
  super-hackish-losing-loop
     (one-laugh output-filespec)
     (and (not (plusp (setq i (1- i)))) (return :hic))
     (and (null no-sleep-p)
	  (sleep (+ (/ (float (random 20.)) 30.0) 0.05)))
     (go super-hackish-losing-loop)))


;;; *EOF*
