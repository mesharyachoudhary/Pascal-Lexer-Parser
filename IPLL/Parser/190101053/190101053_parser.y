%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <bits/stdc++.h>
using namespace std;


// function declarations
void yyerror(const char *s);//displays syntax errors
int yylex(void);
int yyparse(void);
string convertUpper(string s);//converts string to upper case
bool checkreservedKeyword(string s);//checks if a given var
void displayerror(string x);//displays semantic errors


extern int yylineno;
extern FILE* yyin;
extern void yylex_destroy();

vector<string> decl_list; // variable list
vector<pair<string,int>>parsingErrors;//contains the list of syntax and semantic errors with their lines

vector<string> keyword= {"while","or","and","case","goto","label","mod","program","var","begin","end","integer","real","for","read","write","to","do","div"}; // keywords
vector<string> types ={"Integer", "Real"}; //variable types
//symbol table
class SYMTAB{
    unordered_map<string,pair<int,bool>>m;
  public:
    bool checkifpresent(string s){
        bool val = 0;
        if(m.find(s)!=m.end()){
            val=1;
        }
        return val;
    }
    void insertintosymtab(string s,int type,bool initialized){
        m[s]={type,initialized};
    }
    pair<int,bool>getkeyfromsymtab(string s){
        return {m[s].first,m[s].second};
    }
    void setinitialization(string s){
         m[s].second=1;
    }
    void insertintosymtab(string x,int type1)
    {
        // Insert function inserts an identifier into the symbol table

        // Check if symbol table already contains the identifier
        if(m.find(x)==m.end()){
            // Insert into symbol table if all clear
            m[x]={type1,0};       
        }
        else{
            if(type1 != m[x].first){ // Contains same identifier of same type
                displayerror("Redefinition of variable : "+x+" from "+types[m[x].first]+ " to "+types[type1]); // Contains same identifier of different type
            }else{
                displayerror("Redeclaration of variable :  "+x);
            } 
        }
    }
    void printSYMTAB(){
        cout<<"Symbol Table:-";
        cout<<endl;
        cout<<left<<setw(15)<<"Identifier"<<"   "<<setw(15)<<"Dataype"<<setw(15)<<"Initialised"<<endl;
        for(auto x:m){
            cout<<left<<setw(15)<<x.first<<"   "<<setw(15)<<types[x.second.first]<<setw(5)<<x.second.second<<endl;
        }
    }
};
SYMTAB symbol_table;
#define YYERROR_VERBOSE
%}

%start Program

%token PROGRAM 1
%token VAR 2
%token BEGINTOKEN 3
%token END 4
%token ENDDOT  5
%token INTEGER 6
%token REAL  7
%token FOR 8
%token READ 9
%token WRITE 10
%token TO 11
%token DO  12
%token SEMICOLON 13
%token COLON 14
%token COMMA 15
%token ASSIGNOPERATOR 16
%token PLUS 17
%token MINUS 18
%token MULTIPLY 19
%token DIVIDE 20
%token OPENBRACE 21
%token CLOSEBRACE 22
%token IDENTIFIER  23
%token INT 24
%token FLOAT  25

%union
{
    int intValue;
    float floatValue;
    char *stringValue;
}

%type <intValue> type term exp factor

%%
dec            : idlist COLON type 
                        {
                            // When declaring variables check if variables isn't a reserved keyword and insert into symbol table
                            int i=0;
                            while(i<(int)decl_list.size()){
                                string x = decl_list[i];
                                if(!checkreservedKeyword(x)){
                                    displayerror("Variable name can't be a reserved keyword");
                                }
                                else{
                                    symbol_table.insertintosymtab(x,$3);
                                }
                                i++;
                            }
                            while(decl_list.size()){
                                decl_list.pop_back();
                            }
                        }
                        ;

type					: INTEGER {$$=0;}
						| REAL    {$$=1;}
						;
idlist  		: IDENTIFIER 
                        { string temp = yylval.stringValue;
                          decl_list.push_back(temp);}
						
                        | idlist COMMA IDENTIFIER 
                        { string temp = yylval.stringValue;
                          decl_list.push_back(temp);}
						;
stmtlist           : stmt
                        | stmtlist SEMICOLON stmt
                        ;

stmt               : assign
                        | read
                        | write
                        | for
                        ;

Program 				: PROGRAM progname VAR declist BEGINTOKEN stmtlist ENDDOT
                        ;

progname             : IDENTIFIER
                        ;
                        


declist 		: dec
						|  declist SEMICOLON dec
						;

assign                  :  IDENTIFIER ASSIGNOPERATOR exp {
                            bool flag = symbol_table.checkifpresent(yyval.stringValue);
                            if(flag){
                                // Check if type matches in assignment 
                                if(symbol_table.getkeyfromsymtab(yyval.stringValue).first==$3){
                                    symbol_table.setinitialization(yyval.stringValue);
                                }else{
                                    displayerror("Type Mismatch when trying to assign "+types[$3] +" to "+types[symbol_table.getkeyfromsymtab(yyval.stringValue).first]+" variable : "+yylval.stringValue);
                                }

                            }else{
                                // Check if variables is declared when it is being referenced
                                   displayerror("Variable "+string(yylval.stringValue)+" referenced before it was declared");

                            }
                        }
                        ;

term                    : term MULTIPLY factor {bool flag = ($1!=$3);
                                if(!flag){

                                }else{
                                    displayerror("Type Mismatch when trying to multiply "+types[$3] +" and "+types[$1]);
                                }
                           }
                        | term DIVIDE factor {bool flag = ($1!=$3);
                                if(!flag){

                                }else{
                                    displayerror("Type Mismatch when trying to divide "+types[$3] +" and "+types[$1]);
                                }
                           }
                        | factor {$$=$1;}
                        ;

read                    : READ OPENBRACE idlist CLOSEBRACE
                            {
                                // if variables are read using READ statement then they should be initialised 
                                int n=decl_list.size();
                                for(int i=0;i<n;i++){
                                    string x=decl_list[i];
                                    symbol_table.setinitialization(x);                                    
                                }
                                for(int i=0;i<n;i++){
                                    decl_list.pop_back();
                                }
                            }
                        ;

write                   : WRITE OPENBRACE idlist CLOSEBRACE
                            {
                                int n=decl_list.size();
                                for(int i=0;i<n;i++){
                                    decl_list.pop_back();
                                }
                            }
                        ;

exp              : term 
                        | exp PLUS term {bool flag = ($1!=$3); 
                             if(!flag){
                                  //correct
                             }else{
                                 displayerror("Type Mismatch when trying to add "+types[$3] +" and "+types[$1]);
                             }
                            }
                        | exp MINUS term {bool flag = ($1!=$3);
                             if(!flag){
                                  //correct
                             }else{
                                 displayerror("Type mismatch when trying to subtract "+types[$3] +" and "+types[$1]);
                             }
                            }
                        ;

for                     :  FOR indexexp DO body
                        ;

indexexp                :  IDENTIFIER ASSIGNOPERATOR exp TO exp
                            {   bool flag1 = ($3!=$5);
                                if(!flag1){
                                    if(symbol_table.checkifpresent(yyval.stringValue)){
                                        //check if the types are same when assigning
                                        if(symbol_table.getkeyfromsymtab(yyval.stringValue).first!=$3){
                                            displayerror("Type Mismatch when trying to assign "+types[$3] +" to "+types[symbol_table.getkeyfromsymtab(yyval.stringValue).first]+" variable : "+yylval.stringValue);
                                        }
                                        else{
                                            symbol_table.setinitialization(yyval.stringValue);
                                        }
                                    }else{
                                        //check if variables are declared at the time they are referenced
                                        displayerror("Variable "+string(yylval.stringValue)+" referenced before it was declared");
                                    }
                                }else{
                                    displayerror("Type Mismatch when trying to iterate from type "+types[$3] +" to "+types[$5]);
                                }
                            }
                        ;

body                    : stmt
                        | BEGINTOKEN stmtlist END
                        ;

factor                  : IDENTIFIER
                        {
                            // check if symbol table contains identifier
                            bool flag = symbol_table.checkifpresent(yyval.stringValue);
                            if(!flag){
                                // check if variables are referenced before declaration
                                displayerror("Variable "+string(yylval.stringValue)+" referenced before it was declared");
                                $$=0;
                            }
                            else{
                                int initialized = symbol_table.getkeyfromsymtab(yyval.stringValue).second;
                                // check if variable is initialised at the time of use
                                if(initialized!=0){
                                    $$ = symbol_table.getkeyfromsymtab(yylval.stringValue).first;
                                }else{
                                    displayerror("Variable "+string(yylval.stringValue)+" used before it was initialized");
                                    $$ = symbol_table.getkeyfromsymtab(yylval.stringValue).first;
                                } 

                            }
                        }
                        
                        | INT {$$=0;}
                        | MINUS FLOAT {$$=1;}
                        | OPENBRACE exp CLOSEBRACE {$$=$2;}
                        | FLOAT {$$=1;}
                        | MINUS INT {$$=0;}
                
                        ;

%%
//prints the symbol table
void printParser(){
    cout<<endl;
    if(parsingErrors.size()==0) {
        // If error flag is 0 no errors occured and program is parsed succssfully
        symbol_table.printSYMTAB();
    }
    else{
        //symbol_table.printSYMTAB();
    }
}
string convertUpper(string s){
    string temp = s;
    transform(temp.begin(), temp.end(), temp.begin(), ::toupper);
    return temp;
}
//checks if the current variable is a keyword
bool checkreservedKeyword(string s){
    for(int i=0;i<keyword.size();i++){
        string temp=convertUpper(keyword[i]);
        string temp1=convertUpper(s);
        if(temp==temp1){
            return 0;
        }
    }
    return 1;
}
void yyerror(const char *s) {
    // Error function for syntax errors
    parsingErrors.push_back({"SYNTAX ERROR",yylineno});
    cout<<"Syntax Error on line "<<yylineno<<", "<<s<<endl;
	//exit(EXIT_FAILURE);
}
void displayerror(string x){
    // Error function for semantic errors
    parsingErrors.push_back({"SEMANTIC ERROR",yylineno});
    string linenum = to_string(yylineno);
    cout <<"Semantic Error on line ";
    cout<<linenum<<", "<<x<<endl;
}
int main(int argc, char* argv[]) {
    char* filename;
    if(argc == 2) {
        filename = argv[1];
        yyin = fopen(filename, "r+"); // open file
        cout <<endl << "Running Parser on Input File: "<<endl;
        int status = yyparse(); // run yyparse
        printParser();
        fclose(yyin); //close file
        yylex_destroy();
        
        return status;
    }else{
        cout<<"Please enter the correct format of command for execution"<<endl;
        exit(EXIT_FAILURE);
    }

}