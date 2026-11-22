SWI-Prolog 9.x and Racket 8.x. Scheme code is written in #lang racket/base and uses nothing but the built-ins listed for each problem.

What your files contain: only definitions. Racket files start with #lang racket/base. Do not call your functions at the top level and do not print anything when the file is loaded; the grader adds the calls itself. Prolog files must not contain any initialization directive.

How your code is run: Prolog: swipl -q -f id_q1.pl -g main -t halt (runs main), and for other predicates swipl -q -f id_q1.pl -g "<goal>" -t halt. Do not call halt/0 yourself and do not use any initialization directive. Scheme: racket id_q3.rkt and racket id_q4.rkt (the grader adds its own calls to the end of your file).

Only work on the section that was prompted, do not change prior code unless absolutely necessary.
Code must at the end work as intended.
