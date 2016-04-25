%{
	#include <stdio.h>
%}
%locations
/*声明类型*/
%union {
	int type_int;
	float type_float;
	double type_double;
}
/*声明token*/
%token IF THAN ELSE WHILE RETURN STRUCT
%token SEMI COMMA TYPE ID DOT
%token <type_int> INT;
%token <type_float> FLOAT;
%token ASSIGNOP
%token AND OR NOT
%token RELOP
%token PLUS MINUS
%token STAR DIV
%token LC RC 
%token LB RB 
%token LP RP
/*声明非终结符*/
%type <type_double> Exp Program ExtDefList ExtDef Specifier FunDec CompSt ExtDecList VarDec StructSpecifier OptTag
%type <type_double> DefList Tag VarList ParamDec StmtList Stmt Def Dec DecList Args
/*声明运算符的结合性*/
%right ASSIGNOP
%left PLUS MINUS
%left STAR DIV
%left LP RP
/*定义一个LOWER_THAN_ELSE算符*/
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE
%%
Program: ExtDefList 
        ;
ExtDefList:/*empty*/            
	   |ExtDef ExtDefList 
           ;
ExtDef: Specifier ExtDecList SEMI
       | Specifier SEMI
       | Specifier FunDec CompSt
       ;
ExtDecList: VarDec
           | VarDec COMMA ExtDecList
           ;
Specifier: TYPE            
          | StructSpecifier
          ;
StructSpecifier: STRUCT OptTag LC DefList RC
                | STRUCT Tag
                ;
OptTag:/*empty*/ 
       | ID
       ;
Tag: ID 
    ;
VarDec: ID
       | VarDec LB INT RB
       ;
FunDec: ID LP VarList RP
       | ID LP RP
       ;
VarList: ParamDec COMMA VarList
        | ParamDec
        ;
ParamDec: Specifier VarDec
         ;
CompSt: LC DefList StmtList RC
       ;
StmtList:/*empty*/
         |Stmt StmtList
	 ;
Stmt: Exp SEMI
     | CompSt
     | RETURN Exp SEMI
     | IF LP Exp RP Stmt %prec LOWER_THAN_ELSE
     | IF LP Exp RP Stmt ELSE Stmt
     | WHILE LP Exp RP Stmt
    ;
DefList:/*empty*/
        |Def DefList
	;
Def: Specifier DecList SEMI
    ;
DecList: Dec
        | Dec COMMA DecList
        ;
Dec: VarDec
    | VarDec ASSIGNOP Exp
Exp: Exp ASSIGNOP Exp
    | Exp AND Exp {$$ = $1 && $3;}
    | Exp OR Exp {$$ = $1 || $3;}
    | Exp RELOP Exp 
    | Exp PLUS Exp {$$ = $1 + $3;}
    | Exp MINUS Exp {$$ = $1 - $3;}
    | Exp STAR Exp {$$ = $1 * $3;}
    | Exp DIV Exp {$$ = $1 / $3;}
    | LP Exp RP {$$ = $2;}
    | MINUS Exp {$$ = -$2;}
    | NOT Exp {$$ = !$2;}
    | ID LP Args RP 
    | ID LP RP                                                                                                                                  
    | Exp LB Exp RB
    | Exp DOT ID
    | ID
    | INT
    | FLOAT
    ;
Args: Exp COMMA Args
     | Exp
     ;
%%
#include "lex.yy.c"
yyerror(char* msg){
	fprintf(stderr,"error: %s\n",msg);
}
