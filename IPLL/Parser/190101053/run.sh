flex 190101053_lexer.l
yacc -d 190101053_parser.y
g++ y.tab.c lex.yy.c -o parser
./parser input.pas
./parser inputerror.pas
./parser inputerror2.pas