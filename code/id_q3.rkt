#lang racket/base

#|
  Assignment 2 - Scheme: S1. Binary Tree Traversals
  File: id_q3.rkt

  Representation of binary tree:
    - Empty tree: ()
    - Non-empty node: (value left right)
      where left and right are binary trees.
    - Value is a number or a single-character symbol.

  Conventions:
    - Height of () is 0, height of node is 1 + max(height(left), height(right)).
    - A leaf is a node whose left and right subtrees are both (). The empty tree has no leaves.
    - Subtrees are always visited left first, then right.
|#

;; tree-val : (listof any) -> any
;; Extracts the root value from a non-empty binary tree node.
(define (tree-val tree)
  (car tree))

;; tree-left : (listof any) -> (listof any)
;; Extracts the left subtree from a non-empty binary tree node.
(define (tree-left tree)
  (cadr tree))

;; tree-right : (listof any) -> (listof any)
;; Extracts the right subtree from a non-empty binary tree node.
(define (tree-right tree)
  (caddr tree))

;; inorder-helper : (listof any) (listof any) -> (listof any)
;; Recursively collects tree values inorder (left subtree, node, right subtree)
;; into the accumulator acc, which holds the values that come after the current
;; subtree. The left recursive call is in tail position, and all state is passed
;; through function arguments.
(define (inorder-helper tree acc)
  (cond
    [(null? tree) acc]
    [else
      (inorder-helper
        (tree-left tree)
        (cons (tree-val tree)
              (inorder-helper (tree-right tree) acc)))]))

;; tree-inorder : (listof any) -> (listof any)
;; Returns a list containing the values of the binary tree in inorder.
(define (tree-inorder tree)
  (inorder-helper tree '()))

;; print-inorder : (listof any) -> void
;; S1.a: Prints, on one line using display, the list of the values of the tree
;; in inorder (left subtree, node, right subtree), followed by a newline.
(define (print-inorder tree)
  (begin
    (display (tree-inorder tree))
    (newline)))
