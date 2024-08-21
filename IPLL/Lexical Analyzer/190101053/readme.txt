The code was done in linux environment and compiled using g++

(i)The Lex Specification is present in the 190101053_Assign3.l file
(ii)First we generate the 190101053.yy.cc which is the lexical analyzer using the command :- flex -o 190101053.yy.cc 190101053_Assign3.l
(iii)Next we compile the 190101053.yy.cc file using g++ with the command :- g++ 190101053.yy.cc
(iv)Next we run the executable file using the command :- ./a.out < input.p
(v)The tokens are printed along with the token id and line number and also identifier name 
   and integer value in case the token is either in the output.txt file
(vi)The hashtable along with its contents is printed in the terminal
