(in-package :cl-user)

(defpackage #:cl-linux-queue
    (:use :cl :cl-user :cffi)
    (:export 
        :string-to-octets ;
        :octets-to-string ;
        :string-message-to-list
        :octets-message-to-list
        :list-to-string-message
        :list-to-octets-message
        :string-message-to-list-function-maker
        :octets-message-to-list-function-maker
        :list-to-string-message-function-maker
        :list-to-octets-message-function-maker
        :find-from-message-list ;
        :add-to-message-list ;
        ))