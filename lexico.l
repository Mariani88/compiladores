%option noyywrap
%option yylineno 


%{
#include "sintactico.tab.h"
%}

/*definicion de tipos*/

Digit  -?[0-9]{1}        
Int    -?[0-9]{2,}
Float  -?[0-9]+[.]{1}[0-9]+
Char   ["]{1}.{1}["]{1}
String ["]{1}.{2,255}["]{1}
Variable [A-Za-z]+

ignora " "|\t|\n 
Boolean "true"|"false"

/*definicion de palabras reservadas*/

digit	"digit"
int     "int"
float   "float"
char	"char"
string  "string" 
boolean "boolean"
const   "const"

%%
";"        { return findelinea; }
{ignora}+  {}
{digit}	   {return  DEFDIGITO;}
{int}      {return  DEFENTERO;}
{float}    {return  DEFFLOTANTE;}
{char}	   {return  DEFCHAR;}
{const}	   {return  DEFCONSTANTE;}
{string}   {return  DEFSTRING;}
{boolean}  {return  DEFBOOLEANO;}

"="        {return IGUAL;}
"!="       {return DISTINTO;}
","        {return COMA;}
"=="       {return COMPIGUAL;}
"."        {}
">="       {return MAYORIGUAL;}
"<="       {return MENORIGUAL;}
"("        {return PAR_ABRE;}
")"        {return PAR_CIERRA;}
">"        {return MAYOR;}
"<"        {return MENOR;}
"{"        {return LLAVEABRE;}
"}"        {return LLAVECIERRA;}
"+"        {return OPSUMA;}
"-"        {return OPMENOS;}
"*"        {return OPMULT;}
"/"        {return OPDIV;}
"&"        {return AND;}
"||"  	   {return OR;}

"main"	   {return MAIN;}
"if"	   {return IF;}
"else"	   {return ELSE;}
"for"	   {return FOR;}
"while"	   {return WHILE;}


{Digit}    {yylval.numero = atoi(yytext);  return DIGITO;}
{Int}      {return ENTERO;}
{Float}    {return FLOTANTE;}
{Boolean}  {return BOOLEANO;}
{Variable} {return VARIABLE;}
{Char}     {return CARACTER;}
{String}   {return STRING;}


.{256,}    {printf("error lexico %d \n",yylineno);} 
%%
