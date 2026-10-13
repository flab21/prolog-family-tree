% run_queries.pl
% Runs every sample query from queries.txt and prints the answers,
% so the expected output can be checked in one go.
% Usage:   swipl run_queries.pl

:- initialization(main).
:- consult(family_tree).

% show(Label, Goal, Template): print every answer of Goal
show(Label, Goal, Template) :-
    format("~n?- ~w~n", [Label]),
    (   findall(Template, Goal, Answers), Answers \= []
    ->  forall(member(A, Answers), format("   ~w~n", [A]))
    ;   format("   false.~n")
    ).

% check(Label, Goal): yes/no query
check(Label, Goal) :-
    format("~n?- ~w~n", [Label]),
    (   call(Goal) -> format("   true.~n") ; format("   false.~n") ).

main :-
    format("=== 1. Basic facts ===~n"),
    check('parent(robert, michael).', parent(robert, michael)),
    check('male(jake).', male(jake)),
    check('female(jake).', female(jake)),
    show('parent(X, emily).', parent(X, emily), 'X'=X),

    format("~n=== 2. Children of a person ===~n"),
    show('parent(michael, X).', parent(michael, X), 'X'=X),
    show('children_of(robert, L).', children_of(robert, L), 'L'=L),
    show('children_of(sophia, L).', children_of(sophia, L), 'L'=L),

    format("~n=== 3. Grandparent ===~n"),
    check('grandparent(robert, emily).', grandparent(robert, emily)),
    check('grandparent(robert, noah).', grandparent(robert, noah)),
    show('grandparent(X, olivia).', grandparent(X, olivia), 'X'=X),
    show('grandchildren_of(linda, L).', grandchildren_of(linda, L), 'L'=L),
    show('grandmother(X, noah).', grandmother(X, noah), 'X'=X),

    format("~n=== 4. Siblings ===~n"),
    show('sibling(emily, X).   (raw rule, note the duplicate)', sibling(emily, X), 'X'=X),
    show('siblings_of(michael, L).', siblings_of(michael, L), 'L'=L),
    show('siblings_of(sophia, L).', siblings_of(sophia, L), 'L'=L),
    check('sibling(susan, david).', sibling(susan, david)),
    check('sibling(emily, emily).', sibling(emily, emily)),
    show('brother(X, susan).', brother(X, susan), 'X'=X),

    format("~n=== 5. Cousins ===~n"),
    check('cousin(emily, olivia).', cousin(emily, olivia)),
    check('cousin(emily, jake).', cousin(emily, jake)),
    check('cousin(noah, ava).', cousin(noah, ava)),
    show('cousins_of(sophia, L).', cousins_of(sophia, L), 'L'=L),
    show('is_cousin(jake, ethan).', (with_output_to(string(S), is_cousin(jake, ethan)), split_string(S, "", "\n", [T])), T),
    show('is_cousin(jake, emily).', (with_output_to(string(S2), is_cousin(jake, emily)), split_string(S2, "", "\n", [T2])), T2),
    show('uncle(X, emily).', uncle(X, emily), 'X'=X),
    show('aunt(X, sophia).', aunt(X, sophia), 'X'=X),

    format("~n=== 6. Recursive: ancestors and descendants ===~n"),
    show('descendants_of(robert, L).', descendants_of(robert, L), 'L'=L),
    show('descendants_of(michael, L).', descendants_of(michael, L), 'L'=L),
    show('ancestors_of(ava, L).', ancestors_of(ava, L), 'L'=L),
    check('descendant(noah, linda).', descendant(noah, linda)),
    check('descendant(linda, noah).', descendant(linda, noah)),
    show('generations_apart(robert, noah, N).', generations_apart(robert, noah, N), 'N'=N),
    halt.
