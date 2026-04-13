/**************************************************
* puckparser.l
**************************************************/

%{
#include <iostream>
#include <iomanip>
#include "puckparser.tab.h"
using namespace std;

int num_lines = 1;

void writeToken(const char* toktype);

%}

/* ------- OPTIONS ------- */
%option noyywrap
WHITE [ \t]
DIGIT [0-9]
ALPHA [a-zA-Z]
ALPHANUM [a-zA-Z0-9]

%% /* ------ REGEX ------ */
[ \t]	;
\n	{ num_lines++; }
%.*  ;
";" { writeToken("K_SC"); return K_SC; }
"(" { writeToken("K_LPAREN"); return K_LPAREN; }
")" { writeToken("K_RPAREN"); return K_RPAREN; }

"IF" { writeToken("K_IF"); return K_IF; }
"THEN" { writeToken("K_THEN"); return K_THEN; }
"ELSE" { writeToken("K_ELSE"); return K_ELSE; }
"WHILE" { writeToken("K_WHILE"); return K_WHILE; }
"DO"      { writeToken("K_DO"); return K_DO; }
"END" { writeToken("K_END"); return K_END; }
"WRITE" { writeToken("K_WRITE"); return K_WRITE; }
":=" { writeToken("OP_ASSIGN"); return OP_ASSIGN; }
"~" { writeToken("OP_NEG"); return OP_NEG; }

"<"|">"|"="|"#" { writeToken("OP_RELATION"); return OP_RELATION; }
"+"|"-"|"&"|"OR" { writeToken("OP_ADD"); return OP_ADD; }
"*"|"/"|"AND" { writeToken("OP_MULT"); return OP_MULT; }
{ALPHA}({ALPHANUM}|_)* { writeToken("T_IDENT"); return T_IDENT; }
[+-]?{DIGIT}+ { writeToken("T_INTEGER"); return T_INTEGER; }
[+-]?{DIGIT}+\.{DIGIT}+ { writeToken("T_DECIMAL"); return T_DECIMAL; }
\"[^\" \t\n]+\" { writeToken("T_STRING"); return T_STRING; }
. {std::cout<<"Error: In line "<<num_lines<<" with token "<<"'"<<yytext<<"'"<<std::endl;} 

%% /* --------------- EPILOGUE ----------------- */
// Purpose: prints that a token was found
void writeToken(const char* toktype)
{
	cout << "TOKEN: ";
	cout << left << setw(14) << toktype;
	cout << "LEXEME: " << yytext << endl;
}
