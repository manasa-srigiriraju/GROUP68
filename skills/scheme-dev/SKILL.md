Racket v8.18 

---
name: scheme-dev
description: general instructions, conventions, and a self-review checklist for writing Scheme/Racket code.
---

Scheme code is written in #lang racket/base and uses nothing but the built-ins listed for each problem.

What our files contain: only definitions. Racket files start with #lang racket/base. Do not call your functions at the top level and do not print anything when the file is loaded; the grader adds the calls itself.

How our code is run: racket id_q3.rkt and racket id_q4.rkt (the grader adds its own calls to the end of your file).

Scheme rules (apply to S1 and S2)
Only the following built-ins may be used: define, lambda, let, let*, letrec, named let, if, cond (with
else), and, or, not, begin, quote (written '), cons, car, cdr, list, every composition of car and cdr up to
four levels (cadr, cddr, caddr, cdddr, cadddr, cddddr, and so on), null?, pair?, eq?, assq, assoc, the
arithmetic and comparison operators + - * < > <= >= =, max, display and newline. S2 additionally
allows read.
Nothing else from racket/base may be used. In particular: no set! or its relatives, no vectors, hash
tables or strings, no loops (do, for), and no length, append, reverse, map, filter, member, memq,
list-ref or list-tail. If you need such a function, write your own helper (for example my-reverse).

Only work on the section that was prompted, do not change prior code unless absolutely necessary.
Code must at the end work as intended.

Conventions:

1. Use 2 spaces for indentation 
2. Use square brackets [] instead of parentheses () for cond clauses
3. Use define for functions and variables and descriptive names with hyphens
4. Align function arguments vertically if they don't fit on one line
5. Use ; for single-line comments  and #| ... |# for multi-line block comments on high level documentation
6. Document every function using the ;; convention above it giving the types and purpose
7. Prefer cond over deeply nested if expressions

Known failure modes:

1. Parenthesis mismatches. Always double-check that every opening bracket has a closing bracket.
2. Using parentheses instead of brackets in cond
3. Deeply nested ifs. Use cond when necessary and make sure code is readable and concise wherever possible.
4. Misinterpreting natural language constraints, eg testing for positive when asked for non-negative, etc. Be thorough.
5. Ignoring evaluation order, like forgetting that Racket evaluates arguments before applying the function
6. Overcomplicating simple tasks, like use foldl or map instead of a simple recursive helper function or filter. Keep the code readable and clean.

Mandatory self-review checklist to apply before giving each answer:

1. Is the code indented with exactly 2 spaces per level, with no tabs?
2. Are square brackets [] used for all cond clauses?
3. Does every function have a ;; comment block?
4. Are complicated sections interspersed with single-line comments as explanation?
5. Is cond used in place of staircase ifs?
6. Are the parentheses and brackets balanced?
7. Are variable and function names descriptive and written in kebab-case?
8. Are there any obvious infinite loops?
9. Has the code been mentally traced through at least one base case and one recursive case?
10. Is the logic double-checked for edge cases like empty lists, 0, etc?
11. Does the code pass the provided test suite and/or the mental test cases? 
