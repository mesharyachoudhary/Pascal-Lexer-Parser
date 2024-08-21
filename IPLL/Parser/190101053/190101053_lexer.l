%{
#include "y.tab.h"
#include <stdio.h>
#include <bits/stdc++.h>
using namespace std;
int tokencode;
%}

%option noyywrap
%option yylineno

%%
[ \t]			                    ;
\n				                    {}
"PROGRAM"                           {tokencode=1;
                                      return PROGRAM; }
"VAR"                               {tokencode=2;
                                      return VAR; }
"BEGIN"                             {tokencode=3; 
                                      return BEGINTOKEN; }
"END"                               {tokencode=4;
                                      return END; }
"END."                              {tokencode=5;
                                      return ENDDOT;}
"INTEGER"                           {tokencode=6;
                                      return INTEGER; }
"REAL"                              {tokencode=7;
                                      return REAL; }
"FOR"                               {tokencode=8;
                                      return FOR;}
"READ"                              {tokencode=9;
                                      return READ;}
"WRITE"                             {tokencode=10;
                                      return WRITE;}
"TO"                                {tokencode=11;
                                      return TO; }
"DO"                                {tokencode=12;
                                      return DO; }
";"                                 {tokencode=13;
                                      return SEMICOLON; }   
":"                                 {tokencode=14;
                                      return COLON; }
","                                 {tokencode=15;
                                      return COMMA; }
:=					                {tokencode=16;
                                      return ASSIGNOPERATOR; }
"+"                                 {tokencode=17;
                                      return PLUS; }
"-"                                 {tokencode=18;
                                      return MINUS; }
"*"                                 {tokencode=19;
                                      return MULTIPLY; }
"DIV"                               {tokencode=20;
                                      return DIVIDE; }
"("                                 {tokencode=21;
                                      return OPENBRACE; }
")"                                 {tokencode=22;
                                      return CLOSEBRACE; }
[a-zA-Z][_a-zA-Z0-9]*		        {tokencode=23;
                                      char* temp = strdup(yytext); 
                                      yylval.stringValue=temp;
                                      return IDENTIFIER; }
[0-9]+                              {tokencode=24;
                                      return INT; }
[0-9]+(\.[0-9]+)?([Ee][+-]?[0-9]+)? {tokencode=25;
                                      return FLOAT; }

.                                   {tokencode=-1;
                                      cout<< "Lexical Error: Unexpected Character "<<yytext[0]<<" found on line "<<yylineno<<endl; }
%%
