%-----------------------------------------------------------------------------
% Date: 2024-4-05
% Purpose: This is a prolog program that solves Maths Puzzles.

%-----------------------------------------------------------------------------
% Project Description: 
%
% A math puzzle consists of a square grid where each square must be filled with 
% a single digit from 1 to 9 (excluding zero). 
% The puzzle must meet the following criteria:
% 1. No digit is repeated in any row or column.
% 2. All squares along the diagonal from the upper left to the lower right corner 
% have the same value.
% 3. The first square of each row and column (the leftmost square in a row and the 
% topmost square in a column) contains either the sum or the product of all the 
% digits in that row or column.
% 4. The puzzle must have at most one solution.

% There is an example puzzle as query which in left and solved which in right :
%
% |    | 14 | 10 | 35 |           |    | 14 | 10 | 35 |
% | 14 |    |    |    |           | 14 |  7 |  2 |  1 |
% | 15 |    |    |    |    ==>    | 15 |  3 |  7 |  5 |
% | 28 |    |  1 |    |           | 28 |  4 |  1 |  7 |

% library
%
% The clpfd library be added in this programme for numorous arithmetic constraints

:- use_module(library(clpfd)).

%-----------------------------------------------------------------------------
% main body of solved maths puzzle.
% puzzle_solution(+ListOfLists)
% puzzle_solution(Puzzle) which holds when its argument is the 
% representation of a solved maths puzzle.
% 
% Step 1: Check if the Puzzle is the square.
% Step 2: Grasp the inner square from the Puzzle.
% Step 3: Check Puzzle is all  digit between 1–9.
% Step 4 Check all the rows in the Puzzle are distinct.
% Step 5: transpose of Puzzle columns to the rows, i.e. Transposed
% Step 6: Check all the columns in the Puzzle are distinct.
% Step 7: Check the diagonal of the inner square is the same.
% Step 8: Check the arithmetic constraints for the rows and columns.
% Step 9: Label all the variables in the Puzzle.
% Step 10: Ground all variables.


puzzle_solution(Puzzle) :-
    maplist(same_length(Puzzle), Puzzle),
    inner_square(Puzzle, Inner_Puzzle),
    all_digits(Inner_Puzzle),
    maplist(all_distinct, Puzzle),
    transpose(Puzzle, Transposed),
    maplist(all_distinct, Transposed),
    diagonal_same(Inner_Puzzle),
    check_arithmetic(Puzzle),
    check_arithmetic(Transposed),
    maplist(label,Puzzle),
    ground(Puzzle).

% remove_row_head(+List,-List)
% remove_row_head/2 is used to remove the first element of the list.
remove_row_head([_|Rows], Rows).

% inner_square(+ListOfLists,-ListOfLists)
% inner_square/2 is used to Get the inner square from the Puzzle.
inner_square([_|Rows], Inner_Puzzle) :-
    maplist(remove_row_head, Rows, Inner_Puzzle).

% all_digits(+ListOfLists)
% all_digits/1 is used to check all the integers are between 1 to 9.
all_digits(Inner_Puzzle) :-
    maplist(digits, Inner_Puzzle).

% digits(+List)
% digits/1 takes in a lists and unpacks the row to obtain the squares (omitting
% the header) and ensures that each element of Row are digital between 1 and 9. The
% ins/2 function from clpfd is used.
digits(Row) :-
    Row ins 1..9.

% diagonal_same(+ListOfLists)
% diagonal_same/1 is used to check the diagonal of the inner square is the same.
% diagonal_same/2 is take accumulator to check the each element on diagonal of the inner square is the same.
diagonal_same(Inner_Puzzle) :-
    length(Inner_Puzzle, Total),
    diagonal_same(Inner_Puzzle, 0, _, Total).
diagonal_same([], _, _, _).
diagonal_same([Row|Rows], Index, Compare, Total) :-
    nth0(Index, Row, Element),
    (Index == 0 -> Compare = Element; Compare = Element),
    N1 is Index + 1,
    diagonal_same(Rows, N1, Compare, Total).

% check_arithmetic(+ListOfLists)
% check_arithmetic/1 is used to check the arithmetic constraints for each rows.
check_arithmetic([_|Rows]) :-
    maplist(arithmetic, Rows).

% arithmetic(+List)
% arithmetic/1 is used to check the sum or product constraints for the rows and columns in inner_square.
% sum/3 function is used and #= from clpfd is used .
arithmetic([Head|Rows]) :-
    sum(Rows, #=, Head); 
    product(Rows, 1, Head).

% product(+ListOfLists,+Integer,-Integer)
% product/3 is used to calculate the product of the list.
product([], Head, Head).
product([Elm|Rows], Temp, Head) :-
    New_Temp #= Temp * Elm,
    product(Rows, New_Temp, Head).
