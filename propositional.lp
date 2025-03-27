%% Predicates to enable min/max formula size given user input
min_size(1) :- not minimum_formula_size.
min_size(X) :- minimum_formula_size(X).

max_size(X) :- X = size, not maximum_formula_size(_).
max_size(X) :- maximum_formula_size(X).

%% Generates all possible solution predicates.
1 { for(I, T, X) : possible(I, T, X) } 1 :- I = MIN..MAX, min_size(MIN), max_size(MAX).

%% Creates all possible predicates.
%% Connect exclude_attr from UI to the program
possible(I, atom, A) :- attribute(A), I = P..T, min_size(P), max_size(T).
possible(I, neg, J) :- I = P..T-1, J = P..T, min_size(P), max_size(T), J >= I + 1.
possible(I, and, J) :- I = P..T-2, J = P..T-1, min_size(P), max_size(T), J >= I + 1.
possible(I, or, J) :- I = P..T-2, J = P..T-1,min_size(P), max_size(T), J >= I + 1.

%% positive(I, E) captures if a propositional formula at position I is positive for example E.
positive(I, E) :- for(I, atom, F), has(E, F).
positive(I, E) :- for(I, and, X), positive(X, E), positive(Y, E), Y = X+1.
positive(I, E) :- for(I, or, X), positive((X; Y), E), Y = X+1.
positive(I, E) :- for(I, neg, X), not positive(X, E), example(E,_).

%% A formula at position I is correct if classification matches with example's E ground truth.
correct(I, E) :- positive(I, E), example(E, pos), I = 1.
correct(I, E) :- not positive(I, E), example(E, neg), I = 1. 

%% Track incorrectly classified examples
incorrect(I, E) :- example(E,_), not correct(I, E), I = 1.

%% referenced(X) captures the second element in a non-atomic for/3 predicate which refers to another formula
referenced(X) :- for(_, (and;or), X).
referenced(X) :- for(_, (and;or), Y), X = Y+1.
referenced(X) :- for(_, neg, X).

%% Every node must exist
node(I) :- I = P..T, min_size(P), max_size(T).
:- node(I), not referenced(I), I > 1.

%%%%% ==== Validity Constraints ====

%% Ensure that attributes are stored in ascending order
:- for(I, (and;or), X), for(X, atom, B), for(Y, atom, A), I = P..T, X = P..T-1, min_size(P), max_size(T), Y = X+1, A < B.
%% Prevents mixing negation with atom following an (and;or) structure
:- for(I, (and;or), X), for(X, neg, _), for(Y, atom, _), I = P..T, X = P..T-1, min_size(P), max_size(T), Y = X+1.
%% Prevents deeply nested and;or predicates that directly depend on atom;neg predicates.
:- for(I, (and;or), X), for(X, (and;or), _), for(Y, (atom;neg), _), Y = X+1.
:- for(_, neg, X), for(X, neg, _).
:- for(X, and, Y), for(X, and, Z), for(Y, atom, K), for(Z, atom, J), J=K. 
:- for(X, or, Y), for(X, or, Z), for(Y, atom, K), for(Z, atom, J), J=K.

%% F has the form (H AND I) and G (J OR K).
:- for(I, (and;or), X), for(X, and, _), for(Y, or, _), I = P..T, X = P..T-1, min_size(P), max_size(T), Y = X+1.
%% For any two non-atom nodes, ensure that the child index of the earlier one is lower.
:- for(I, neg, I1), for(J, (neg; and; or), I2), I < J, I1 >= I2.
%% Additional rule for (and; or): Ensure I1 + 1 < I2.
:- for(I, (and; or), I1), for(J, (neg; and; or), I2), I < J, I1 + 1 >= I2.

%% Checks that if the first predicate is a (neg; or; and), that it points to the second predicate.
:- for(1, (and;or;neg), X), X > 2.
%% Checks that all predicates except the first one, are referenced.
:- for(X, atom, B), not referenced(X), X > 1.

%%%%%%% Further setting up of predicates for use cases

% Calculate formula information
formula_size(S) :- S = #count { I : for(I, _, _) }.
error_count(Error) :- Error = #count { E : incorrect(1, E) }.
min_error_count(MinErr) :- MinErr = #min { E : incorrect(1, E)}.

% Set up constraints for max/min error count
:- maximum_error_count(X), error_count(Y), Y > X.
:- minimum_error_count(X), error_count(Y), Y < X.

:- maximum_formula_size(X), formula_size(Y), Y > X.
:- minimum_formula_size(X), formula_size(Y), Y < X.

% Ensure formula iteration works
cycle_formula(Opt) :- Opt = false, next_formula(ID).

%% Optimization toggled with a switch to output minimal error solutions
:- error_count(X), min_error_count(Y), X != Y, compute_optimal.

%% Include / Exclude attributes when clicked
:- not for(_, _, A), include_attr(A).
:- for(_, _, A), exclude_attr(A).

#show for/3.