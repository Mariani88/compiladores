%option noyywrap
%option yylineno 


%{
#include "sintactico.tab.h"
#include <string.h>
%}

/*definicion de tipos*/

Int    -?[0-9]{1,}
Float  -?[0-9]+[.]{1}[0-9]+
Char   ["]{1}.{1}["]{1}
String ["]{1}.{1,255}["]{1}
Variable [A-Za-z]{1,50}

ignora " "|\t|\n 
Boolean "true"|"false"

/*definicion de palabras reservadas*/

int     "int"
float   "float"
char    "char"
string  "string" 
boolean "boolean"

%%
";"        { return FINDELINEA; }
{ignora}+  {}
{int}      {strcpy (yylval.tipo, yytext);return  DEFENTERO;}
{float}    {strcpy (yylval.tipo, yytext);return  DEFFLOTANTE;}
{char}     {strcpy (yylval.tipo, yytext);return  DEFCHAR;}
{string}   {strcpy (yylval.tipo, yytext);return  DEFSTRING;}
{boolean}  {strcpy (yylval.tipo, yytext);return  DEFBOOLEANO;}

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
"||"       {return OR;}
"!"        {return NOT;}

"main"     {return MAIN;}
"if"       {return IF;}
"else"     {return ELSE;}
"for"      {return FOR;}
"while"    {return WHILE;}


{Int}      {yylval.numero = atoi(yytext);return ENTERO;}
{Float}    {yylval.flotante = atof(yytext);return FLOTANTE;}
{Boolean}  {strcpy (yylval.variable, yytext);return BOOLEANO;}
{Variable} {strcpy (yylval.variable, yytext); return VARIABLE;}
{Char}     {strcpy (yylval.variable, yytext);return CARACTER;}
{String}   {strcpy (yylval.variable, yytext);return STRING;}


.{256,}    {printf("error lexico %d \n",yylineno);} 
%%
