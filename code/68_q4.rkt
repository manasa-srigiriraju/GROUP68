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

;; Higher‑order inserter creator.
(define (make-inserter x len-ok?)
  (lambda (lst)
    (cond
      [(null? lst)
       (if (len-ok? 0) (list x) '())]
      [else
       (let ((transformed (my-map (lambda (elem)
                                   (if (pair? elem)
                                       ((make-inserter x len-ok?) elem)
                                       elem))
                                 lst)))
         (if (len-ok? (my-length lst))
             (cons x transformed)
             transformed))])))

;; Final definition using make‑inserter.
(define (insert-if-short x lst n)
  ((make-inserter x (lambda (len) (< len n))) lst)))
;; Driver: reads x, lst, n from stdin and displays the resulting list.
(define (print-insert-result)
  (let* ([x (read)]
         [lst (read)]
         [n (read)])
    (display (insert-if-short x lst n))
    (newline)))
