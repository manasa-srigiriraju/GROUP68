SWI-Prolog 9.2.9

---
name: prolog-dev
description: general instructions, conventions, common pitfalls, and self-review checklist for writing SWI-Prolog code. Use this skill whenever asked to generate or debug Prolog predicates.
---

What our files should contain: only definitions. Do not call your functions at the top level and do not print anything when the file is loaded; the grader adds the calls itself. Prolog files must not contain any initialization directive.

How our code is run: Prolog: swipl -q -f id_q1.pl -g main -t halt (runs main), and for other predicates swipl -q -f id_q1.pl -g "<goal>" -t halt. Do not call halt/0 yourself and do not use any initialization directive. 

Only work on the section that was prompted, do not change prior code unless absolutely necessary.
Code must at the end work as intended.

Conventions:
1. comment on why each rule is used in a clause
2. use /* ... */ for high level descriptions and % or %% for predicate documentation
3. use % on separate lines, not trailing, withing clauses to explain complex goals or code
4. use descriptive, readable names with underscores
5. do not start predicate names with an uppercase letter

Known failure modes:
1. forgetting that , binds more tightly than ->. exercise caution and use parentheses where required
2. misusing is for unification. is/2 is not the same as =/2
3. forgetting or misplacing cuts (!)
4. ignoring argument modes. not all arguments are initialised, so treat them accordingly
5. \+/1 does not bind variables. keep this in mind.
6. unnecessary backtracking. keep the code as linear and easy to read as possible, within reason.

Mandatory self-review checklist to apply before giving each answer:
1. a space after every comma separating arguments/goals but no space inside list elements
2. no space between the predicate name and the opening parenthesis
3. every predicate should have a %% comment block describing its purpose and argument modes
4. confusing parts (like cuts or if-then-else) should be explained with a % comment
5. all cuts placed intentionally and their effects commented
6. is/2 used only where the right-hand side is guaranteed to be intantiated
7. predicate should behave correctly when given uninstantiated variable in the output position
8. must mentally trace the code through at least one base case and one recursive case
9. code must avoid obvious infinite loops
10. parentheses used wherever -> should be applied before ,
11. consistent indentation
    
