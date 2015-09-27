%option noyywrap
%option yylineno 


%{
#include "sintactico.tab.h"
%}

/*definicion de tipos*/

Digit  -?[0-9]{1}        
Int    -?[0-9]{2,}
Float  -?[0-9]+[.]{1}[0-9]+
Char   .{1}
String ["]{1}.{2,255}["]{1}

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
{ignora}   {;}
{digit}	   {printf ("Ingresaste digit\n"); }
{int}      {printf ("Ingresaste int\n");}
{float}    {printf ("Ingresaste float\n");}
{char}	   {printf ("Ingresaste char\n");}
{const}	   {printf ("Ingresaste constante\n");}
{string}   {printf ("Ingresaste string\n");}
{boolean}  {printf ("Ingresaste boolean\n");}

"="        {printf("igual\n");}
";"        {printf("Fin sentencia\n");}
"!="       {printf("Diferente\n");}
","        {printf("Coma\n");}
"=="       {printf("Igual logico\n");}
"."        {printf("Punto\n");}
">="       {printf("Signo mayor-igual\n");}
"<="       {printf("Signo menor-igual\n");}
"("        {printf("parentesis apertura\n"); return PAR_ABRE;}
")"        {printf("parentesis cierre\n"); return PAR_CIERRA;}
">"        {printf("mayor\n");}
"<"        {printf("menor\n");}
"{"        {printf("llave de apertura\n");}
"}"        {printf("llave de cierre\n");}
"+"        {printf("mas\n"); return (OPSUMA);}
"-"        {printf("menos\n"); return OPMENOS;}
"*"        {printf("por\n"); return OPMULT;}
"/"        {printf("dividir\n"); return OPDIV;}
"&"        {printf("y logico\n");}
"||"  	   {printf ("o logico\n");}

"main"	   {printf("Inicio archivo programa\n");}
"if"	   {printf("if condicion\n");}
"else"	   {printf("else condicion\n");}
"for"	   {printf("for iteracion\n");}
"while"	   {printf("while condicion\n");}


{Digit}    {printf ("Ingresaste Digit\n"); yylval.numero = atoi(yytext);  return (DIGITO);}
{Int}      {printf ("Ingresaste Int\n"); }
{Float}    {printf ("Ingresaste Float\n");}
{Char}     {printf ("Ingresaste Char\n");}
{Boolean}  {printf ("Ingresaste Booleano\n");}
{String}   {printf ("Ingresaste String\n");}


.{256,}    {printf("error lexico %d \n",yylineno);} 
%%



