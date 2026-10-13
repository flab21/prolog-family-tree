% family_tree.pl
% MSCS-632 Assignment 8 - Building a Family Tree in Prolog
% Frenie Labrador
%
% A made up "average American" family, the Millers, across four generations.
% Load it in SWI-Prolog with:   swipl family_tree.pl
% then type queries at the ?- prompt (see queries.txt).
%
%   Generation 1:  robert + linda
%   Generation 2:  michael (married jennifer), susan (married mark), david (married karen)
%   Generation 3:  emily, jake  (michael + jennifer)
%                  olivia, ethan (susan + mark)
%                  sophia (david + karen)
%   Generation 4:  noah, ava (emily + chris)

% ---------------------------------------------------------------
% Part 1: basic facts
% parent(Parent, Child).
% ---------------------------------------------------------------

% generation 1 -> 2
parent(robert, michael).
parent(linda,  michael).
parent(robert, susan).
parent(linda,  susan).
parent(robert, david).
parent(linda,  david).

% generation 2 -> 3
parent(michael,  emily).
parent(jennifer, emily).
parent(michael,  jake).
parent(jennifer, jake).

parent(susan, olivia).
parent(mark,  olivia).
parent(susan, ethan).
parent(mark,  ethan).

parent(david, sophia).
parent(karen, sophia).

% generation 3 -> 4
parent(emily, noah).
parent(chris, noah).
parent(emily, ava).
parent(chris, ava).

% gender facts (note: no space between male and the paren,
% "male (john)." from the assignment example is a syntax error in SWI-Prolog)
male(robert).
male(michael).
male(mark).
male(david).
male(jake).
male(ethan).
male(chris).
male(noah).

female(linda).
female(jennifer).
female(susan).
female(karen).
female(emily).
female(olivia).
female(sophia).
female(ava).

% ---------------------------------------------------------------
% Part 2: derived relationships (rules)
% ---------------------------------------------------------------

father(X, Y) :- parent(X, Y), male(X).
mother(X, Y) :- parent(X, Y), female(X).

child(X, Y) :- parent(Y, X).          % X is a child of Y

% grandparent: X is a parent of someone who is a parent of Y
grandparent(X, Y) :-
    parent(X, Z),
    parent(Z, Y).

grandfather(X, Y) :- grandparent(X, Y), male(X).
grandmother(X, Y) :- grandparent(X, Y), female(X).

% sibling: X and Y share a parent, and X is not Y.
% Without X \= Y everyone comes back as their own sibling.
% Because both parents are listed, plain backtracking returns each
% sibling twice (once through each parent). siblings_of/2 below
% uses setof to clean that up.
sibling(X, Y) :-
    parent(P, X),
    parent(P, Y),
    X \= Y.

brother(X, Y) :- sibling(X, Y), male(X).
sister(X, Y)  :- sibling(X, Y), female(X).

% cousin: X and Y have parents who are siblings
cousin(X, Y) :-
    parent(PX, X),
    parent(PY, Y),
    sibling(PX, PY).

% aunt / uncle, a nice side effect once sibling works
uncle(X, Y) :- parent(P, Y), sibling(X, P), male(X).
aunt(X, Y)  :- parent(P, Y), sibling(X, P), female(X).

% ---------------------------------------------------------------
% Part 4: recursive rules
% ---------------------------------------------------------------

% ancestor: base case is a parent, recursive case is a parent
% of an ancestor. Grandparent is just the 2-step case of this.
ancestor(X, Y) :- parent(X, Y).
ancestor(X, Y) :- parent(X, Z), ancestor(Z, Y).

% descendant is the same relation read the other way
descendant(X, Y) :- ancestor(Y, X).    % X is a descendant of Y

% generation gap, counts how many parent links separate X and Y
generations_apart(X, Y, 1) :- parent(X, Y).
generations_apart(X, Y, N) :-
    parent(X, Z),
    generations_apart(Z, Y, N1),
    N is N1 + 1.

% ---------------------------------------------------------------
% Part 3: query helpers
% These collect answers into a sorted list with no duplicates,
% so the user gets one clean answer instead of pressing ; a lot.
% setof fails if there are no answers, so the helpers return []
% in that case instead of just saying false.
% ---------------------------------------------------------------

children_of(P, L)    :- ( setof(C, parent(P, C), L)     -> true ; L = [] ).
parents_of(C, L)     :- ( setof(P, parent(P, C), L)     -> true ; L = [] ).
siblings_of(X, L)    :- ( setof(S, sibling(X, S), L)    -> true ; L = [] ).
cousins_of(X, L)     :- ( setof(C, cousin(X, C), L)     -> true ; L = [] ).
grandchildren_of(X, L) :- ( setof(G, grandparent(X, G), L) -> true ; L = [] ).
ancestors_of(X, L)   :- ( setof(A, ancestor(A, X), L)   -> true ; L = [] ).
descendants_of(X, L) :- ( setof(D, descendant(D, X), L) -> true ; L = [] ).

% yes/no style check that prints a sentence
is_cousin(X, Y) :-
    (   cousin(X, Y)
    ->  format("Yes, ~w and ~w are cousins.~n", [X, Y])
    ;   format("No, ~w and ~w are not cousins.~n", [X, Y])
    ).
