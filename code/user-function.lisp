(in-package :cl-http-message)
;(setf a (list (list "1" "2" "3" "4" "5") (list (cons "1" "2") (cons "3" "4") (cons "5" "6") (cons "7" "8")) (list "12345" 5)))
;(setf b (list (list "1" "2" "3") (list (cons "1" "2") (cons "3" "4") (cons "5" "6") (cons "7" "8")) (list "12345" 5)))

(declaim (inline vector-to-string))
(defun vector-to-string (vector-message)
    (map 'string #'code-char vector-message) )
    
(declaim (inline string-to-vector))
(defun string-to-vector (string-message)
    (map '(vector (unsigned-byte 8)) #'char-code string-message) )
    
(defun find-from-list (message-list content-name)
    (let ((content-list (cadr message-list)))
        (block mark-place
            (loop for (k . v) in content-list do
                (if (equalp k content-name)
                    (return-from mark-place v)
                    nil )))))
    
(defun add-to-list (message-list face-content-cons)
    (nconc (cadr message-list) (list face-content-cons)) )

(defun split-octets (the-content the-vector vector-length list-length) 
    (declare (fixnum list-length vector-length))
    (let ((the-path (search the-vector the-content)))
        (if (or (= list-length 0) (null the-path))
            (list the-content)
            (cons
                (subseq the-content 0 the-path)
                (split-octets
                    (subseq the-content (+ the-path vector-length))
                    the-vector
                    vector-length
                    (if (= list-length -1) 
                    -1 
                    (1- list-length) ))))))

(defun remove-empty-item (the-list)
    (remove-if (lambda (a) (equalp #() a)) the-list))

(let (  (get-vector     (string-to-vector "GET"))
        (head-vector    (string-to-vector "HEAD")) 
        (host-vector    (string-to-vector "Host: "))
        (cookie-vector  (string-to-vector "Cookie: ")) )
    (defun vector-to-list (http-octets)
        (let (  vector-length head-end body-start head-list 
                http-hair http-face-list http-hair-list 
                http-method http-url-line http-url url-end 
                http-arg-line http-arg-list http-arg-cons-list 
                http-face-cons-list host-end http-host http-cookie 
                http-body http-body-length )
        (setq vector-length (length http-octets))
        (if (< vector-length 7)
            nil
            (progn
                (setq head-end (search #(13 10 13 10) http-octets))
                (if head-end
                    (progn
                        (setq   
                            http-head       (subseq http-octets 0 head-end)
                            body-start      (+ 4 head-end)
                            head-list       (split-octets http-head #(13 10) 2 32)
                            http-hair       (car head-list)
                            http-face-list  (cdr head-list)
                            http-hair-list  (split-octets http-hair #(32) 1 3)
                            http-method     (car http-hair-list)
                            http-url-line   (cadr http-hair-list) )
                        (if (or (equalp http-method get-vector) (equalp http-method head-vector))
                            nil
                            (if (< body-start vector-length)
                                (setq 
                                    http-body (subseq http-octets body-start)
                                    http-body-length (length http-body) ) ;(- vector-length body-start)
                                nil))
                        (setq url-end (search #(63) http-url-line))
                        (if url-end
                            (setq
                                http-url            (subseq http-url-line 0 url-end)
                                http-arg-line       (subseq http-url-line (1+ url-end))
                                http-arg-list       (split-octets http-arg-line #(38) 1 64)
                                http-arg-list       (remove-empty-item http-arg-list)
                                http-arg-cons-list  
                                    (mapcar 
                                        (lambda (a) 
                                            (let ((b (search #(61) a)))
                                                (if b
                                                    (cons (subseq a 0 b) (subseq a (1+ b)))
                                                    nil)))
                                        http-arg-list ) )
                            (setq http-url http-url-line) )
                        (setq 
                            http-face-cons-list 
                                (mapcar 
                                    (lambda (a)
                                        (let ((b (search #(32) a)))
                                            (if b
                                                (cons (subseq a 0 (1+ b)) (subseq a (1+ b)))
                                                nil )))
                                    http-face-list )
                            http-host (find-from-list http-face-list host-vector)
                            http-cookie (find-from-list http-face-list cookie-vector) )
                        (if http-host
                            (progn
                                (setq host-end (search #(58) http-host :from-end t))
                                (if host-end
                                    (setq http-host (subseq http-host 0 host-end))
                                    nil))
                            nil)
                        (list
                            (list http-method http-url http-arg-cons-list http-host http-cookie)
                            http-face-cons-list
                            (list http-body http-body-length) ))
                    nil ))))))
    
(defun list-to-vector (message-list)
    (let (  (http-hair-list (car message-list))
            (http-face-list (cadr message-list))
            (http-body-list (caddr message-list)))
        (let ((head-vector 
                (string-to-vector
                    (with-output-to-string (http-head-message)
                        (progn
                            (format http-head-message "~A ~A ~A~c~c" (car http-hair-list) (cadr http-hair-list) (caddr http-hair-list) #\return #\newline)
                            (format http-head-message "Content-Length: ~A~c~c" (cadr http-body-list) #\return #\newline)
                            (loop for face-content-cons in http-face-list do
                                (format http-head-message "~A~A~c~c" (car face-content-cons) (cdr face-content-cons) #\return #\newline) )
                            (format http-head-message "~c~c" #\return #\newline))))))
             (concatenate '(vector (unsigned-byte 8)) head-vector (car http-body-list)))))
