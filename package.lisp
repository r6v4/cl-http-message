(in-package :cl-user)

(defpackage #:cl-linux-queue
    (:use :cl :cl-user)
    (:export 
        :string-to-vector
        :vector-to-string 
        :vector-to-list
        :list-to-vector
        :find-from-list 
        :add-to-list 
        :split-octets
        :remove-empty-item ))
