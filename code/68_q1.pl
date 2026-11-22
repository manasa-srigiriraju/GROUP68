/*
 * Department Assignment Puzzle, Reloaded
 *
 * Four friends (Alex, Ben, Carla, Dana) each have a unique department,
 * favorite programming language, and project preference.
 *
 * Departments : research, development, design, testing
 * Languages   : python, java, c++, javascript
 * Projects    : AI, web, embedded, data
 *
 * Clues:
 * 1. The friend who prefers the AI project does not work in research and is not Dana.
 * 2. Alex does not work in development and does not prefer C++.
 * 3. The friend working in the testing department likes Python.
 * 4. Ben prefers web projects and does not work in testing.
 * 5. The friend whose favorite language is Java works in the design department.
 * 6. The project preference of Carla is not embedded, and her department is not development.
 * 7. The favorite language of Dana is not Java, and she works in research or testing.
 * 8. The friend who prefers data projects works in research and does not use JavaScript.
 *
 * Representation:
 * A solution is a list of four terms p(Name, Dept, Lang, Project) in the order:
 * Alex, Ben, Carla, Dana.
 */

%% departments(-Departments)
%  List of the four available department atoms.
departments([research,development,design,testing]).

%% languages(-Languages)
%  List of the four available programming language atoms.
languages([python,java,'c++',javascript]).

%% projects(-Projects)
%  List of the four available project preference atoms.
projects(['AI',web,embedded,data]).

%% clue(+ClueNumber, +Solution)
%  Succeeds exactly when clue number ClueNumber holds in a fully filled-in
%  Solution list of terms p(Name, Dept, Lang, Project).

% Clue 1: The friend who prefers the AI project does not work in research and is not Dana.
clue(1, Solution) :-
    % Locate the friend preferring the AI project
    member(p(Name, Dept, _Lang, 'AI'), Solution),
    % Check that the AI project person does not work in research
    Dept \= research,
    % Check that the AI project person is not Dana
    Name \= 'Dana'.

% Clue 2: Alex does not work in development and does not prefer C++.
clue(2, Solution) :-
    % Locate Alex in the solution list
    member(p('Alex', Dept, Lang, _Project), Solution),
    % Check that Alex does not work in development
    Dept \= development,
    % Check that Alex does not prefer C++
    Lang \= 'c++'.

% Clue 3: The friend working in the testing department likes Python.
clue(3, Solution) :-
    % Locate the friend working in testing and verify their language is Python
    member(p(_Name, testing, python, _Project), Solution).

% Clue 4: Ben prefers web projects and does not work in testing.
clue(4, Solution) :-
    % Locate Ben in the solution list
    member(p('Ben', Dept, _Lang, Project), Solution),
    % Check that Ben prefers web projects
    Project = web,
    % Check that Ben does not work in testing
    Dept \= testing.

% Clue 5: The friend whose favorite language is Java works in the design department.
clue(5, Solution) :-
    % Locate the friend whose favorite language is Java and verify their department is design
    member(p(_Name, design, java, _Project), Solution).

% Clue 6: The project preference of Carla is not embedded, and her department is not development.
clue(6, Solution) :-
    % Locate Carla in the solution list
    member(p('Carla', Dept, _Lang, Project), Solution),
    % Check that the project preference of Carla is not embedded
    Project \= embedded,
    % Check that the department of Carla is not development
    Dept \= development.

% Clue 7: The favorite language of Dana is not Java, and she works in research or testing.
clue(7, Solution) :-
    % Locate Dana in the solution list
    member(p('Dana', Dept, Lang, _Project), Solution),
    % Check that the favorite language of Dana is not Java
    Lang \= java,
    % Check that Dana works in either research or testing
    (Dept = research ; Dept = testing).

% Clue 8: The friend who prefers data projects works in research and does not use JavaScript.
clue(8, Solution) :-
    % Locate the friend preferring data projects
    member(p(_Name, Dept, Lang, data), Solution),
    % Check that this friend works in research
    Dept = research,
    % Check that this friend does not use JavaScript
    Lang \= javascript.

% CLUE 9: The friend whose favorite language is Java prefers the embedded project.
clue(9, Solution) :-
    % Locate the friend whose favorite language is Java and verify project is embedded
    member(p(_Name, _Dept, java, embedded), Solution).

%% candidate_solution(-Solution)
%  Generates a candidate assignment of departments, languages, and projects
%  to the four friends, ensuring all attributes are unique.
candidate_solution(Solution) :-
    % Template for the four friends in fixed order
    Solution = [p('Alex', DeptA, LangA, ProjA),p('Ben', DeptB, LangB, ProjB),p('Carla', DeptC, LangC, ProjC),p('Dana', DeptD, LangD, ProjD)],
    % Assign unique departments
    departments(Depts),
    permutation(Depts, [DeptA,DeptB,DeptC,DeptD]),
    % Assign unique languages
    languages(Langs),
    permutation(Langs, [LangA,LangB,LangC,LangD]),
    % Assign unique projects
    projects(Projs),
    permutation(Projs, [ProjA,ProjB,ProjC,ProjD]).

%% check_clues(+ClueList, +Solution)
%  Recursively verifies that every clue number in ClueList holds for the given Solution.
check_clues([], _Solution).
check_clues([Clue|Rest], Solution) :-
    % Check the current clue number against the candidate solution
    clue(Clue, Solution),
    % Recursively verify the remaining clues in the list
    check_clues(Rest, Solution).

%% count_solutions(+Active, -N)
%  Counts the number of distinct solutions that satisfy all clues in the
%  Active list, ignoring any clues not in the list.
count_solutions(Active, N) :-
    % Find all solutions satisfying each clue in Active
    findall(Solution, (
        candidate_solution(Solution),
        check_clues(Active, Solution)
    ), Solutions),
    % Count the total number of solutions found
    length(Solutions, N).

%% solve(-Solution)
%  Derives a valid assignment of attributes to the four friends that satisfies
%  all attribute uniqueness constraints and clues 1 through 8.
solve(Solution) :-
    % Generate a candidate solution with unique attributes
    candidate_solution(Solution),
    % Verify all clues from 1 to 8
    clue(1, Solution),
    clue(2, Solution),
    clue(3, Solution),
    clue(4, Solution),
    clue(5, Solution),
    clue(6, Solution),
    clue(7, Solution),
    clue(8, Solution).

%% print_solution(+Solution)
%  Recursively prints the attributes of each friend in the exact layout:
%  Name = [Dept, Lang, Project].
print_solution([]).
print_solution([p(Name, Dept, Lang, Project)|Rest]) :-
    % Output the name and attribute list of the friend
    format('~w = [~w, ~w, ~w]~n', [Name,Dept,Lang,Project]),
    % Recurse on the remaining friends
    print_solution(Rest).

%% main
%  Main predicate executed by the grading harness. Solves the puzzle
%  and prints the first valid solution found.
main :-
    % Derive a solution that satisfies clues 1 through 8
    solve(Solution),
    % Cut to commit to the single solution and prevent unwanted backtracking
    !,
    % Display the solution in the specified four-line format
    print_solution(Solution).
