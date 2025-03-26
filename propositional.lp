%% Generates all possible solution predicates.
1 { for(I, T, X) : possible(I, T, X) } 1 :- I = 1..size.

%% Creates all possible predicates.
%% Connect exclude_attr from UI to the program
possible(I, atom, A) :- attribute(A), I = 1..size.
possible(I, neg, J) :- I = 1..size-1, J = 1..size, J >= I + 1.
possible(I, and, J) :- I = 1..size-2, J = 1..size-1, J >= I + 1.
possible(I, or, J) :- I = 1..size-2, J = 1..size-1, J >= I + 1.

%% positive(I, E) captures if a propositional formula at position I is positive for example E.
positive(I, E) :- for(I, atom, F), has(E, F).
positive(I, E) :- for(I, and, X), positive(X, E), positive(Y, E), Y = X+1.
positive(I, E) :- for(I, or, X), positive((X; Y), E), Y = X+1.
positive(I, E) :- for(I, neg, X), not positive(X, E), example(E,_).

%% A formula at position I is correct if classification matches with example's E ground truth.
correct(I, E) :- positive(I, E), example(E, pos), I = 1. %I = 1..size.%,
correct(I, E) :- not positive(I, E), example(E, neg), I = 1. %I = 1..size.%, 

%% Track incorrectly classified examples
incorrect(I, E) :- example(E,_), not correct(I, E), I = 1. %I = 1..size.%,

%% referenced(X) captures the second element in a non-atomic for/3 predicate which refers to another formula
referenced(X) :- for(_, (and;or), X).
referenced(X) :- for(_, (and;or), Y), X = Y+1.
referenced(X) :- for(_, neg, X).

%% Every node must exist
node(I) :- I = 1..size.
:- node(I), not referenced(I), I > 1.

%%%%% ==== Validity Constraints ====

%% Ensure that attributes are stored in ascending order
:- for(I, (and;or), X), for(X, atom, B), for(Y, atom, A), I = 1..size, X = 1..size-1, Y = X+1, A < B.
%% Prevents mixing negation with atom following an (and;or) structure
:- for(I, (and;or), X), for(X, neg, _), for(Y, atom, _), I = 1..size, X = 1..size-1, Y = X+1.
%% Prevents deeply nested and;or predicates that directly depend on atom;neg predicates.
:- for(I, (and;or), X), for(X, (and;or), _), for(Y, (atom;neg), _), Y = X+1.
:- for(_, neg, X), for(X, neg, _).

%% F has the form (H AND I) and G (J OR K).
:- for(I, (and;or), X), for(X, and, _), for(Y, or, _), I = 1..size, X = 1..size-1, Y = X+1.
%% For any two non-atom nodes, ensure that the child index of the earlier one is lower.
:- for(I, neg, I1), for(J, (neg; and; or), I2), I < J, I1 >= I2.
%% Additional rule for (and; or): Ensure I1 + 1 < I2.
:- for(I, (and; or), I1), for(J, (neg; and; or), I2), I < J, I1 + 1 >= I2.

%% Checks that if the first predicate is a (neg; or; and), that it points to the second predicate.
:- for(1, (and;or;neg), X), X > 2.
%% Checks that all predicates except the first one, are referenced.
:- for(X, atom, B), not referenced(X), X > 1.

%%%%%%% UI Constraints WIP

% Calculate formula information
formula_size(S) :- S = #count { I : for(I, _, _) }.
error_count(Error) :- Error = #count { E : incorrect(1, E) }.
min_error_count(MinErr) :- MinErr = #min { E : incorrect(1, E)}.

:- maximum_error_count(X), error_count(Y), Y > X.
:- minimum_error_count(X), error_count(Y), Y < X.

% Calculate min/max size

% Ensure formula iteration works
cycle_formula(Opt) :- Opt = false, next_formula(ID).
cycle_formula(Opt) :- Opt = true, next_optimal_formula(ID).

% User constraints for formula size
%:- formula_size(S), _clinguin_assume(min_size(Min), true), S < Min.
%:- formula_size(S), _clinguin_assume(max_size(Max), true), S > Max.

% User constraints for error bounds
%:- error_count(E), _clinguin_assume(min_error(Min), true), E < Min.
%:- error_count(E), _clinguin_assume(max_error(Max), true), E > Max.
%%%%%%%%%% WIP

% Optimization that is toggled with a Switch - Now min Error
%opt_weight(1,E) :- incorrect(1, E), compute_optimal.

% opt_weight_count(Error) :- Error = #count { E : opt_weight(1, E) }.

:- error_count(X), min_error_count(Y), X != Y, compute_optimal.

% #minimize { W : opt_weight_count(W) }.

:- not for(_, _, A), include_attr(A).
:- for(_, _, A), exclude_attr(A).


% Only optimize when requested (how to implement)
% #maximize { 1, E : correct(1, E) }.
#show for/3.