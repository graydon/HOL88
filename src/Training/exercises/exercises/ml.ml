% ===================================================================== %
% HOL TRAINING COURSE: exercises in simple ml programming.		%
%									%
% The aim of the exercises in this file is to get you acquainted with 	%
% ml syntax and with some of the basic constructs of the ml programming %
% language. 								%
% ===================================================================== %

% ---------------------------------------------------------------------	%
% Write an ml function:							%
%									%
%    sum_list: int list -> int						%
%									%
% that computes the sum of the integers in a list.			%
% --------------------------------------------------------------------- %

letrec sum_list l = < *** put your code here *** >;;

% --------------------------------------------------------------------- %
% Test your function as follows:					%
% --------------------------------------------------------------------- %
sum_list [1;2;3;4;5;6;7;8;9] = 45;;
sum_list [1;2;3;2;1] = itlist (\x y.x+y) [3;2;1;2;1] 0;;

% ---------------------------------------------------------------------	%
% Define an ml function:						%
%									%
%    reduce :* list -> * list						%
%									%
% that removes duplicate elements from a list. The order of the output	%
% list is immaterial, but no duplicates should occur. For example:	%
%									%
%    reduce [1;2;3;2;1] 						%
%									%
% should return the list [3;2;1].  HINT: the ml function		%
%									%
%    mem : * -> * list -> bool    					%
%									%
% tests for membership in a list.					%
% --------------------------------------------------------------------- %

letrec reduce l = 
       if (null l) then [] 
          else < *** something *** >;;

% --------------------------------------------------------------------- %
% Test your function as follows:					%
% --------------------------------------------------------------------- %
reduce [1;2;3;2;1];;
reduce [1;2;3;5;2;6;5;2];;
reduce [true;false;true];;
reduce [(1,2); (2,1); (1,2)];;

% ---------------------------------------------------------------------	%
% Define a function:  rotations: * list -> * list list			%
% that takes a list and outputs a list of all the rotations of the 	%
% input list.								%
%									%
% E.g. "rotations [1;2;3]" should produce  [[1;2;3];[2;3;1];[3;1;2]]	%
% and  "rotations [1;1;2]" should produce  [[1;1;2];[1;2;1];[2;1;1]]	%
%									%
% HINT: Define an auxiliary function "rotate" that has an extra list	%
% 	parameter.							%
% --------------------------------------------------------------------- %

let rotations l = rotate [] l
    whererec rotate l1 l2 = 
	     < *** put a definition of "rotate" here *** > ;;

% ---------------------------------------------------------------------	%
% Use the ML function "itlist" to define a function that finds the	%
% maximum non-negative integer in a list. (itlist is documented in the	%
% ML handbook).								%
% --------------------------------------------------------------------- %

let max_list l = itlist (< *** something *** >) l 0;;

% --------------------------------------------------------------------- %
% Test your function as follows:					%
% --------------------------------------------------------------------- %
max_list [1;2;3;3;4;5;5;6;4;3;1;4;5;6;7;6;4;3;2] = 7;;

% --------------------------------------------------------------------- %
% Write a function:							%
% 									%
%	sum :bool -> bool -> bool -> bool				%
%									%
% that computes the one-bit sum of three one-bit numbers 		%
% (where true represents "1" and false represents "0").			%
%									%
% E.g. "sum true false false" should give true,				%
%      "sum true true true"   should give true,				%
%      "sum true false true"  should give false, etc...			%
% --------------------------------------------------------------------- %

% --------------------------------------------------------------------- %
% Solution:								%
% --------------------------------------------------------------------- %
let sum a b c = (if c then (a = b) else not(a = b));;

% --------------------------------------------------------------------- %
% Write a similar function, carry, that computes the carry when three	%
% bits are added.							%
%									%
% NOTE: "&" is the ML infix and-operation, "or" is infix or.		%
%									%
% "carry true false false" should be false,				%
% "carry true true true" should be true...	etc			%
% --------------------------------------------------------------------- %

let carry a b c = < *** body of definition here *** >;;

% ---------------------------------------------------------------------	%
% Define a function 							%
%									%
% val: bool list -> int							%
%									%
% that takes a list of booleans representing a natural number (least	%
% significant bit at the head) and returns the number that is 		%
% represented.  I.e. val [false;true;true] should return 6.		%
%									%
% First define a function pow:int->int such that pow 0 = 1, pow 1 = 2,	%
% pow 2 = 4, pow 3 = 8, pow 4 = 16... etc.				%
% --------------------------------------------------------------------- %

letrec pow n = < *** put your code here *** >;;

let val l = < *** put your code here *** >;;

% --------------------------------------------------------------------- %
% Test your function as follows:					%
% --------------------------------------------------------------------- %
val [true] = 1;;
val [false] = 0;;
val [true;true;false;true] = 11;;
val [true;true;false;true;false] = 11;;
val [false;true;false] = 2;;
val [true;true;true;true] = (pow 4) - 1;;


% ---------------------------------------------------------------------	%
% Define the inverse of val... I.e:					%
% rep 11 should return [true;true;false;true]				%
% --------------------------------------------------------------------- %

% --------------------------------------------------------------------- %
% The definition of "evenp" (tests if a number is even) follows:	%
% --------------------------------------------------------------------- %
let evenp n = ((n/2)*2 = n);;

letrec rep n = < *** put your definition here *** >;;

% ---------------------------------------------------------------------	%
% Define a function add: bool list -> bool list -> bool list that	%
% adds two natural numbers represented by lists of booleans.  The 	%
% representations give the least significant bits first...		%
%									%
% E.g. add [true;true] [false;true] should return [true;false;true]	%
% and  add [true] [true;true] should return [false;false;true]		%
%									%
% (Use "sum" and "carry" defined above....)				%
% --------------------------------------------------------------------- %

let add l1 l2 = addfn false l1 l2 
    whererec addfn carry_in l1 l2 = < *** put your code here ***>;;

% --------------------------------------------------------------------- %
% Test your function as follows:					%
% --------------------------------------------------------------------- %
add [false] [true;false;true;true] = [true;false;true;true];;
add [true;false;true;true] [true] = [false;true;true;true];;
add [true;true;true;true] [true] = [false;false;false;false;true];;
add [true;true;true;true] [true;false;true] = [false;false;true;false;true];;
  
% --------------------------------------------------------------------- %
% Use rep, val and add (defined above) to define a function 		%
% plus: int -> int -> int that adds two natural numbers by first	%
% changing them into their binary (list) representation and then adds	%
% them using "add" and returns the result given by "val".		%
% --------------------------------------------------------------------- %

let plus a b = < *** definition of plus *** >;;

% --------------------------------------------------------------------- %
% Test your function as follows:					%
% --------------------------------------------------------------------- %
plus 0 99 = 99;;
plus 99 0 = 99;;
plus 1023 1023 = 2046;;
plus 1 1023 = 1024;; 
plus 1023 2001 = 3024;; 

