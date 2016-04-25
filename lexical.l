%{/*此为定义部分*/ 
	#include "syntax.tab.h"
	extern FILE* yyin;
	int yycolumn = 1;
        #define YY_USER_ACTION \
          yylloc.first_line = yylloc.last_line = yylineno; \
          yylloc.first_column = yycolumn; \
          yylloc.last_column = yycolumn + yyleng - 1; \
          yycolumn +=yyleng;
%}
%option yylineno
letter [a-zA-Z]
digit [0-9]
dile [0-9a-zA-Z]
digitp [1-9]
exponent e|E
%%
(" "|"\t")+   
"\n" {yycolumn = 1;} 
"0"|{digitp}{digit}*|"0"{digit}+|"0x"{dile}+|"0X"{dile}+ {yylval.type_int = atoi(yytext);return INT;}
{digit}+"."{digit}*|{digit}*"."{digit}*{exponent}("+"|"-")?{digit}* {yylval.type_float = atof(yytext);return FLOAT;}
";" {return SEMI;}
"," {return COMMA;}
"=" {return ASSIGNOP;}
">"|"<"|">="|"<="|"=="|"!=" {return RELOP;}
"+" {return PLUS;}
"-" {return MINUS;}
"*" {return STAR;}
"/" {return DIV;}
"&&" {return AND;}
"||" {return OR;}
"." {return DOT;}
"!" {return NOT;}
"int"|"float" {return TYPE;}
"(" {return LP;}
")" {return RP;}
"[" {return LB;}
"]" {return RB;}
"{" {return LC;}
"}" {return RC;}
"struct" {return STRUCT;}
"return" {return RETURN;}
"if" {return IF;}
"else" {return ELSE;}
"while" {return WHILE;}
("_"|{letter})+{dile}* {return ID;}
. {printf("Error type A at Line %d: Mysterious characters \'%s\'\n",yylineno,yytext);}
%%
