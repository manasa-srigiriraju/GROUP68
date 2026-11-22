#lang racket/base

;; insert-if-short.rkt
;; Implements insert-if-short and print-insert-result according to assignment specifications.
;; Only allowed Scheme primitives are used (no length, append, map, etc.).

(provide insert-if-short print-insert-result)

;; Custom length function (tail‑recursive)
(define (my-length lst)
  (let loop ((l lst) (cnt 0))
    (if (null? l)
        cnt
        (loop (cdr l) (+ cnt 1)))))

;; Custom map function using an accumulator and manual reverse.
(define (my-reverse lst)
  (let recur ((src lst) (acc '()))
    (if (null? src)
        acc
        (recur (cdr src) (cons (car src) acc)))))

(define (my-map f lst)
  (let loop ((l lst) (out '()))
    (if (null? l)
        (my-reverse out)
        (loop (cdr l) (cons (f (car l)) out)))))

;; Main function: inserts x at front of every list whose original length < n.
(define (insert-if-short x lst n)
  (cond
    [(null? lst)
     (if (< 0 n) (list x) '())] ; empty list case
    [else
     ;; Transform each element: recurse on sublists.
     (let ((transformed (my-map (lambda (elem)
                                   (if (pair? elem)
                                       (insert-if-short x elem n)
                                       elem))
                                 lst)))
       (if (< (my-length lst) n)
           (cons x transformed)
           transformed))])))
;; Driver: reads x, lst, n from stdin and displays the resulting list.
(define (print-insert-result)
  (let* ([x (read)]
         [lst (read)]
         [n (read)])
    (display (insert-if-short x lst n))
    (newline)))
