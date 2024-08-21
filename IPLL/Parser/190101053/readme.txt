Name - Mesharya M Choudhary
Roll No. - 190101053 
The code was done in linux environment using g++ 

Commands to Run:-
(i)flex 190101053_lexer.l
(ii)yacc -d 190101053_parser.y
(iii)g++ y.tab.c lex.yy.c -o parser
(iv)./parser input.pas
(v)./parser inputerror.pas
(vi)./parser inputerror2.pas

Alternatively we can simply run:-   chmod +x run.sh
                                    ./run.sh

The output is printed in the terminal 

In case there are no lexical,syntactic and semantic errors the symtab is correctly printed to the terminal
with the details of the variable type and initialization status.

In case there are syntactic or semantic errors symtab is not printed and the errors are printed to the terminal. 

In case there is only lexical error the parser prints it and then continues with 
the execution and finally the symtab is correctly printed.