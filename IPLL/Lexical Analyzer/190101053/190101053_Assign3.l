%{
#include <bits/stdc++.h>
using namespace std;
fstream fout;

class Node{
  public:
   string symbol; 
   int type;
   Node* next;

   Node(){
	   this->type=-1;
	   this->symbol="";
	   this->next=NULL;
   }
   Node(int type,string symbol){
       this->type=type;
	   this->symbol=symbol;
	   this->next=NULL;
   }

};
//hashtable[22][10] stores the identifiers
//hashtable[23][10] stores the integers
Node* hashtable[24][10];
//initializes the hashed symbol table
void initialize(){
	for(int i=0;i<10;i++){
		hashtable[22][i]=NULL;
		hashtable[23][i]=NULL;
	}
}
//hashes the string which is used to index into the hashtable
int hashval(string s){
	int val=0;
	for(int i=0;i<s.length();i++){
        val+=(int)s[i];
	}
	return val%10;
}
//searches for identifiers and numbers
Node* SearchVal(int type,string s){
	Node* head=hashtable[type][hashval(s)];
	while(head!=NULL){
	    if(head->type==type && head->symbol==s){
			return head;
		}
		head=head->next;
	}
	return NULL;
}
//inserts the current token into the appropriate hashtable (if it is identifier or number)
Node* InsertVal(int type,string s){
	Node* head=hashtable[type][hashval(s)];
	if(head==NULL){
		hashtable[type][hashval(s)]=new Node(type,s);
		return hashtable[type][hashval(s)];
	}
	while(head->next!=NULL){
		head=head->next;
	}
	head->next=new Node(type,s);
	head=head->next;
	return head;
}
// Lex variables
//stores the return value after calling install_id and install_num functions
Node* Entry;
int lines = 1;


Node* install_id(); // Install ID
Node* install_num(); // Install num

%}
%option noyywrap
%%
[ \t]+ {}
"\n" {lines++;}
PROGRAM {  return 1; }
VAR {  return 2; }
BEGIN {  return 3; }
END {  return 4; }
"END." {  return 5; }
INTEGER {  return 6; }
FOR {  return 7; }
READ {  return 8; }
WRITE {  return 9; }
TO {  return 10; }
DO {  return 11; }
";" {  return 12; }
":" {  return 13; }
"," {  return 14; }
":=" {  return 15; }
"+" {  return 16; }
"-" {  return 17; }
"*" {  return 18; }
DIV {  return 19; }
"(" {  return 20; }
")" {  return 21; }
[A-Za-z][A-Za-z0-9]* {  Entry = install_id(); return 22; }      // insert identifier in hashtable
[+/-]?[0-9]+ {  Entry = install_num(); return 23; }             // insert number in hashtable


%%

Node* install_id(){ 
     if(SearchVal(22,yytext)){
        return SearchVal(22,yytext);
	 }else{
		 return InsertVal(22,yytext);
	 }
}
Node* install_num(){
     if(SearchVal(23,yytext)){
        return SearchVal(23,yytext);
	 }else{
		 return InsertVal(23,yytext);
	 }
}

int main()
{   fout.open("output.txt", ios::out);
	initialize();
	fout<<"Line    TokenType   Token Specifier"<<endl;
	int i;
	int prev = 0;
	string curr="";
	while((i=yylex()) != 5){
		
		// Read line by line and print output in format
        if(lines==prev){
            curr="";
		}else{
			curr=to_string(lines);
		}
		prev=lines;
		fout<<curr;
		for(int j=0;j<10-curr.length();j++){
			fout<<" ";
		}
		if(i<10){
			fout<<" ";
			fout<<i;
			for(int j=0;j<8;j++){
				fout<<" ";
			}
		}else{
			fout<<i;
			for(int j=0;j<8;j++){
				fout<<" ";
			}			
		}
		if(i==22){
			fout <<"  ^" << Entry->symbol << endl;
		}else if (i==23){
			fout <<"  #" << Entry->symbol << endl;
		}else{
			fout<<endl;
		} 
		
		
	}
	if(lines==prev){
            curr="";
	}else{
			curr=to_string(lines);
	}
	fout<<curr;
	for(int j=0;j<10-curr.length();j++){
		fout<<" ";
	}
	fout<<" ";
	fout<<5;
	for(int j=0;j<8;j++){
		fout<<" ";
	}
	fout<<endl;
	//prints the hashtable 
	for(int j=22;j<24;j++){
		if(j==22){
			cout<<"IDENTIFIERS IN THE SYMBOL TABLE"<<endl;
		}else{
			cout<<"INTEGERS IN THE SYMBOL TABLE"<<endl;
		}
		for(int i=0;i<10;i++){
		   cout<<"Bucket "<<i<<": ";
           Node* head=hashtable[j][i];
		   if(head==NULL){
			   cout<<"NULL"<<endl;
		   }
		   while(head!=NULL){
			   cout<<head->symbol;
			   if(head->next){
			   cout<<"-->";
			   }
			   head=head->next;
		   }
		   cout<<endl;
		}
	}
}
