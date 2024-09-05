(asdf:defsystem cl-http-message
    :name "cl-http-message"
    :description "parsing and generation of http messages"
    :author "r6v4@pm.me"
    :version "2.0"
    :depends-on () 
    :serial t
    :components (
        (:static-file "LICENSE")
        (:file "package")
        (:module "code"
            :serial t
            :components
                (   (:file "user-function") ))
        ;(:module "test"
        ;    :serial t
        ;    :components
        ;        (  (:file "example-1")
        ;           (:file "example-2")))
        ))
