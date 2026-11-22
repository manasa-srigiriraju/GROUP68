/*
 * Problem 2: Form a Valid Arithmetic Equation
 * File: id_q2.pl
 *
 * Given a list of non-negative integers [n1, n2, ..., nk], insert the
 * operators +, -, *, / and exactly one = between the numbers (using every
 * number once, in the given order, with optional parentheses) so that both
 * sides of the equation have the same integer value.
 *
 * Representation and Constraints:
 * - Equation format: L = R, where L is an expression over n1..nj and R is an
 *   expression over n(j+1)..nk (1 <= j < k).
 * - Division constraint: Division is exact (remainder == 0) and divisor != 0.
 *   This applies to every internal division node.
 * - Sub-expressions may evaluate to negative values.
 * - No unary minus, and numbers are never concatenated.
 * - Canonical parenthesization:
 *   * and / bind tighter (level 2) than + and - (level 1).
 *   Operators are left-associative.
 *   Left operand is parenthesized only if top operator has strictly lower precedence.
 *   Right operand is parenthesized if top operator has lower or equal precedence.
 *   Single numbers are never parenthesized.
 * - Output format: SWI-Prolog string with no whitespace.
 */

:- use_module(library(lists)).

%% op_precedence(+Op, -Precedence)
%  Associates an integer precedence level with each arithmetic operator.
%  * and / bind tighter (level 2) than + and - (level 1).
op_precedence(+, 1).
op_precedence(-, 1).
op_precedence(*, 2).
op_precedence(/, 2).

%% split_list(+List, -Left, -Right)
%  Partitions List into two non-empty contiguous sublists Left and Right
%  preserving original element ordering such that append(Left, Right, List) holds.
split_list(List, [X|Left], [Y|Right]) :-
    % Decompose List into two non-empty segments
    append([X|Left], [Y|Right], List).

%% eval_op(?Op, +LeftVal, +RightVal, -Result)
%  Evaluates arithmetic operator Op on LeftVal and RightVal.
%  Enforces exact integer division and prevents division by zero without exceptions.
eval_op(+, LeftVal, RightVal, Result) :-
    % Evaluate integer addition
    Result is LeftVal + RightVal.
eval_op(-, LeftVal, RightVal, Result) :-
    % Evaluate integer subtraction
    Result is LeftVal - RightVal.
eval_op(*, LeftVal, RightVal, Result) :-
    % Evaluate integer multiplication
    Result is LeftVal * RightVal.
eval_op(/, LeftVal, RightVal, Result) :-
    % Divisor must be non-zero
    RightVal =\= 0,
    % Division must produce zero remainder (exact integer division)
    LeftVal rem RightVal =:= 0,
    % Compute exact integer quotient
    Result is LeftVal // RightVal.

%% expr_tree(+List, -Tree, -Val)
%  Recursively builds a valid arithmetic expression Tree over the ordered sequence
%  of numbers in List, and computes its exact integer value Val.
expr_tree([N], num(N), N) :-
    % Base case: Leaf node holding a single non-negative integer
    integer(N),
    N >= 0.
expr_tree(List, op(Op, LeftTree, RightTree), Val) :-
    % Recursive case: List must have at least two numbers to form an operation
    List = [_,_|_],
    % Partition List into two non-empty sublists
    split_list(List, LeftList, RightList),
    % Recursively construct left sub-expression and evaluate its integer value
    expr_tree(LeftList, LeftTree, LeftVal),
    % Recursively construct right sub-expression and evaluate its integer value
    expr_tree(RightList, RightTree, RightVal),
    % Apply valid operator and calculate resulting integer value
    eval_op(Op, LeftVal, RightVal, Val).

%% tree_to_string(+Tree, -String)
%  Converts an expression Tree into its canonical SWI-Prolog string representation,
%  applying operator precedence and left-associativity parenthesization rules.
tree_to_string(num(N), String) :-
    % Base case: Single numbers are never written in parentheses
    number_string(N, String).
tree_to_string(op(Op, LeftTree, RightTree), String) :-
    % Recursively convert left subtree to string
    tree_to_string(LeftTree, LeftString),
    % Recursively convert right subtree to string
    tree_to_string(RightTree, RightString),
    % Determine whether left operand requires parentheses
    (   LeftTree = op(LeftOp, _, _),
        op_precedence(LeftOp, LeftPrec),
        op_precedence(Op, ParentPrec),
        LeftPrec < ParentPrec
    ->  % Enclose left operand in parentheses because child operator has lower precedence
        atomics_to_string(["(",LeftString,")"], LeftFormatted)
    ;   % Leave left operand unparenthesized when precedence is equal or higher
        LeftFormatted = LeftString
    ),
    % Determine whether right operand requires parentheses
    (   RightTree = op(RightOp, _, _),
        op_precedence(RightOp, RightPrec),
        op_precedence(Op, ParentPrec),
        RightPrec =< ParentPrec
    ->  % Enclose right operand in parentheses because child operator has lower or equal precedence
        atomics_to_string(["(",RightString,")"], RightFormatted)
    ;   % Leave right operand unparenthesized when precedence is strictly higher
        RightFormatted = RightString
    ),
    % Concatenate formatted left operand, operator symbol, and formatted right operand
    atomics_to_string([LeftFormatted,Op,RightFormatted], String).

%% generate_equation(+List, -Equation)
%  Task P2.a. Unifies Equation with one valid canonical equation string for List.
%  Fails if no valid equation exists, including for lists of length 0 or 1.
%  Generates further valid equations upon backtracking.
generate_equation(List, Equation) :-
    % Verify list contains at least two elements to allow splitting into L = R
    List = [_,_|_],
    % Partition the numbers into non-empty left and right sets
    split_list(List, LeftList, RightList),
    % Formulate valid expression on the left side
    expr_tree(LeftList, LeftTree, LeftVal),
    % Formulate valid expression on the right side
    expr_tree(RightList, RightTree, RightVal),
    % Ensure both expressions evaluate to the exact same integer value
    LeftVal =:= RightVal,
    % Convert left expression tree to canonical string format
    tree_to_string(LeftTree, LeftString),
    % Convert right expression tree to canonical string format
    tree_to_string(RightTree, RightString),
    % Assemble full equation string with equality operator
    atomics_to_string([LeftString,"=",RightString], Equation).

%% all_equations(+List, -Equations)
%  Finds all distinct valid canonical equations for List and collects them in a list.
%  Yields an empty list if no valid equation exists.
all_equations(List, Equations) :-
    % Collect all equations generated by generate_equation/2 on backtracking
    findall(Eq, generate_equation(List, Eq), Equations).
