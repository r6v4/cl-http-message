# cl-http-message

## Project description
This package is used for preliminary parsing and generation of http messages in common-lisp

## Project structure
```text
cl-http-message/
    cl-http-message.asd                #define project.
    package.lisp                       #define package and export symbol.
    code/                              #source code.
        user-function.lisp             #some function for user.
    test/                              #test part.
        example-1.lisp                 #simple example.

```

## Project loading
```bash
git clone https://github.com/r6v4/cl-http-message.git

cd cl-http-message

sbcl
```
```common-lisp
(require :asdf)

(pushnew
    (probe-file "../cl-http-message")
    asdf:*central-registry* :test #'equal)

(asdf:load-system :cl-http-message)
```

## Project usage
```common-lisp
(setf
    http-message
#(71 69 84 32 47 49 50 51 52 53 32 72 84 84 80 47 49 46 49 13 10 72 111 115 116
  58 32 49 50 55 46 48 46 48 46 49 58 56 48 56 48 13 10 85 115 101 114 45 65
  103 101 110 116 58 32 87 103 101 116 47 49 46 50 49 46 51 13 10 65 99 99 101
  112 116 58 32 42 47 42 13 10 65 99 99 101 112 116 45 69 110 99 111 100 105
  110 103 58 32 105 100 101 110 116 105 116 121 13 10 67 111 110 110 101 99 116
  105 111 110 58 32 75 101 101 112 45 65 108 105 118 101 13 10 13 10))

(cl-http-message:vector-to-list http-message)

(let* ((http-body (cl-http-message:string-to-vector "1234554321"))
       (http-body-length (length http-body)) )
    (cl-http-message:list-to-vector
        (list
            (list "HTTP/1.1" 200 "OK")
            (list
                (cons "Connection: "         "Keep-Alive")
                (cons "Server: "             "common-lisp")
                (cons "Set-Cookie: "         "mykey=myvalue; expires=Mon, 17-Jul-2017 16:06:00 GMT; Max-Age=31449600; Path=/; secure")
                (cons "X-Frame-Options: "    "SAMEORIGIN") )
        (list http-body http-body-length) )))

;(cl-http-message:vector-to-string *)

```

## API
```common-lisp
;output of vector-to-list
(list
    (list http-method http-url http-arg-list http-host http-cookie)
    http-face-cons-list
    (list http-body body-length))

;input of list-to-vector
(list
    (list http-version http-status-code http-state)
    http-face-cons-list
    (list http-body body-length))

```
```text
list vector-to-list (array message-octets);
array list-to-vector (list http-message-list);
list split-octets (array message-octets, array split-vector, int vector-length, int list-max-length);
array string-to-vector (string http-message-string);
string vector-to-string (array http-message-vector);
list remove-empty-item (list have-some-empty-list);
array find-from-list (list some-cons-list, array key-of-item);
list add-to-list (list old-list);

```
