(in-package :cl-user)

(defpackage #:cl-linux-queue
    (:use :cl :cl-user :cffi)
    (:export 
        :string-to-vector
        :vector-to-string 
        :string-message-to-list
        :vector-message-to-list
        :list-to-string-message
        :list-to-vector-message
        :find-from-message-list 
        :add-to-message-list 
        ))
