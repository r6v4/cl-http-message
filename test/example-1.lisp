(in-package :cl-http-message)

(let ((http-url-line (string-to-vector "/12345?a=1&&b=2&&c=3&&d=4&&e=5"))
      url-end http-url http-arg-line http-arg-list http-arg-cons-list )
    (setq url-end (search #(63) http-url-line) )
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
                    http-arg-list ))
        (setq http-url http-url-line) )
    http-arg-cons-list )
