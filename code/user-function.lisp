(setf a (list (list "1" "2" "3" "4" "5") (list (cons "1" "2") (cons "3" "4") (cons "5" "6") (cons "7" "8")) (list "12345" 5)))

(declaim (inline string-to-octets))
(defun string-to-octets (string-message)
    (map 'string #'code-char string-message) )
    
(declaim (inline octets-to-string))
(defun octets-to-string (octets-message)
    (map '(vector (unsigned-byte 8)) #'char-code octets-message) )
    
(defun find-from-message-list (message-list content-name)
    (let ((content-list (cadr message-list)))
        (block mark-place
            (loop for (k . v) in content-list do
                (if (equalp k content-name)
                    (return-from mark-place v)
                    nil )))))
    
(defun add-to-message-list (message-list face-content-cons)
    (nconc (cadr message-list) (list face-content-cons)) )
    
#|
(let (( ))
    (defun string-message-to-list (string-message)
        nil ))
|#

(defun octets-message-to-list (octets-message)
    nil )
    
(defun list-to-string-message (message-list)
    (let (  (http-hair (car message-list))
            (http-face (cadr message-list))
            (http-body (caddr message-list)))
        (with-output-to-string (http-message)
            (progn
                (format http-message "~A ~A ~A~c~c" (car http-hair) (cadr http-hair) (caddr http-hair) #\return #\newline)
                (format http-message "Content-Length: ~A~c~c" (cadr http-body) #\return #\newline)
                (loop for face-content-cons in http-face do
                    (format http-message "~A~A~c~c" (car face-content-cons) (cdr face-content-cons) #\return #\newline) )
                (format http-message "~c~c~A" #\return #\newline (car http-body))))))
    
(defun list-to-octets-message (message-list)
    (string-to-octets (list-to-string-message http-list)))
