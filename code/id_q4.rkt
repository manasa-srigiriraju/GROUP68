#lang racket/base

;; insert-if-short.rkt
;; Implements insert-if-short and print-insert-result according to assignment specifications.
;; Only allowed Scheme primitives are used (no length, append, map, etc.).

(provide insert-if-short print-insert-result)

;; Helper: determine if the length of a list is less than n.
;; Stops early when count reaches n to avoid full traversal.
(define (length-less-than? lst n)
  (let loop ((l lst) (count 0))
    (cond
      [(or (null? l) (>= count n)) (< count n)]
      [else (loop (cdr l) (+ count 1))])))

;; Tail‑recursive reverse using accumulator.
(define (my-reverse lst)
  (let recur ((src lst) (acc '()))
    (if (null? src)
        acc
        (recur (cdr src) (cons (car src) acc)))))

;; Core transformer that processes each element, preserving order.
;; Returns a proper list.
(define (transform-elements elems x n)
  (let loop ((remaining elems) (out '()))
    (if (null? remaining)
        (my-reverse out)
        (let ((elem (car remaining)))
          (cond
            [(pair? elem)
             ;; elem is a sublist; recursively transform it first.
             (let ((new-sub (insert-if-short x elem n)))
               (loop (cdr remaining) (cons new-sub out)))]
            [else
             ;; atom – keep as‑is.
             (loop (cdr remaining) (cons elem out))])))))

;; Main function: inserts x at front of every list whose original length < n.
(define (insert-if-short x lst n)
  (cond
    [(null? lst)
     (if (< 0 n) (list x) '())] ; empty list case
    [else
     (let ((transformed (transform-elements lst x n)))
       (if (length-less-than? lst n)
           (cons x transformed)
           transformed))]))

;; Driver: reads x, lst, n from stdin and displays the resulting list.
(define (print-insert-result)
  (let* ([x (read)]
         [lst (read)]
         [n (read)])
    (display (insert-if-short x lst n))
    (newline)))
