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
(setf http-message #(71 69 84 32 47 49 50 51 52 53 32 72 84 84 80 47 49 46 49 13 10 72 111 115 116
  58 32 49 50 55 46 48 46 48 46 49 58 56 48 56 48 13 10 85 115 101 114 45 65
  103 101 110 116 58 32 87 103 101 116 47 49 46 50 49 46 51 13 10 65 99 99 101
  112 116 58 32 42 47 42 13 10 65 99 99 101 112 116 45 69 110 99 111 100 105
  110 103 58 32 105 100 101 110 116 105 116 121 13 10 67 111 110 110 101 99 116
  105 111 110 58 32 75 101 101 112 45 65 108 105 118 101 13 10 13 10))

(cl-http-message:vector-to-list http-message)

```

## API
```text
list vector-to-list (vector message-octets);
```
