%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "tabla.c"

//-- Lexer prototype required by bison, aka getNextToken()
int yylex(); 
int yyerror(const char *p) { printf("error sintactico\n");}
%}


%union {
char cadena;
int numero;
char variable[50];
char tipo[10];
float flotante;
}

%token findelinea

%token <tipo> DEFDIGITO
%token <tipo> DEFENTERO
%token <tipo> DEFFLOTANTE
%token <tipo> DEFCHAR
%token <tipo> DEFCONSTANTE
%token <tipo> DEFSTRING
%token <tipo> DEFBOOLEANO

%token IGUAL
%token DISTINTO
%token COMA
%token COMPIGUAL
%token MAYORIGUAL
%token MENORIGUAL
%token PAR_ABRE
%token PAR_CIERRA
%token MAYOR
%token MENOR
%token LLAVEABRE
%token LLAVECIERRA
%token OPSUMA
%token OPMENOS
%token OPMULT 
%token OPDIV
%token AND
%token OR

%token MAIN
%token IF
%token ELSE
%token FOR
%token WHILE
%token CARACTER
%token BOOLEANO
%token <variable>VARIABLE
%token STRING


%token <numero> DIGITO
%token <numero> ENTERO
%token <flotante> FLOTANTE


%type <numero> expresion termino factor

%%

programa: MAIN LLAVEABRE cuerpo LLAVECIERRA;

cuerpo: sentencia findelinea cuerpo | sentencia findelinea

sentencia: declaracion| asignacion | expresion

asignacion: VARIABLE IGUAL expresion 
			| VARIABLE IGUAL VARIABLE 

declaracion: DEFDIGITO       VARIABLE    {agregar (  $1, $2);}
			|DEFENTERO       VARIABLE    {agregar (  $1, $2);}
	      	|DEFFLOTANTE     VARIABLE    {agregar (  $1, $2);}
	        |DEFCHAR         VARIABLE    {agregar (  $1, $2);}
	        |DEFCONSTANTE    VARIABLE    {agregar (  $1, $2);}
	        |DEFSTRING       VARIABLE    {agregar (  $1, $2);}
	        |DEFBOOLEANO     VARIABLE    {agregar (  $1, $2);}
	      	
expresion: expresion OPSUMA termino { $$ = $1 + $3;}
	   | expresion OPMENOS termino { $$ = $1 - $3;}
	   | termino  { $$ = $1;}

termino: termino OPMULT factor {$$ = $1*$3;}
	 | termino OPDIV factor {$$ = $1/$3;}
	 | factor  { $$ = $1;}

factor: DIGITO {$$ = $1;}
		|ENTERO   {$$ = $1;}
		|FLOTANTE  {$$ = $1;}
	| PAR_ABRE expresion PAR_CIERRA { $$ = $2;}






	  
%%

int main (){
	
	yyparse ();
	imprimirTabla();
	return 0;

}