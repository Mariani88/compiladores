%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "tabla.c"

//-- Lexer prototype required by bison, aka getNextToken()
int yylex(); 
int yyerror(const char *mensaje) { printf("Error sintactico: %s\n",mensaje);}
%}


%union {
    char cadena;
    int numero;
    char variable[50];
    char tipo[10];
    float flotante;
}

%token FINDELINEA

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

cuerpo: sentencia FINDELINEA cuerpo | sentencia FINDELINEA

sentencia: declaracion| asignacion | expresion

asignacion: VARIABLE IGUAL expresion {if(!existe($1)){yyerror("Variable no definida.");}}
			| VARIABLE IGUAL VARIABLE {if(!existe($1)|| !existe($3)){yyerror("Variable no definida.");}}

declaracion: 	 DEFDIGITO       VARIABLE    {if(!existe($2)){agregar (  $1, $2);}else{yyerror("La variable definida ya existe.");}}
		|DEFENTERO       VARIABLE    {if(!existe($2)){agregar (  $1, $2);}else{yyerror("La variable definida ya existe.");}}
	      	|DEFFLOTANTE     VARIABLE    {if(!existe($2)){agregar (  $1, $2);}else{yyerror("La variable definida ya existe.");}}
	        |DEFCHAR         VARIABLE    {if(!existe($2)){agregar (  $1, $2);}else{yyerror("La variable definida ya existe.");}}
	        |DEFCONSTANTE    VARIABLE    {if(!existe($2)){agregar (  $1, $2);}else{yyerror("La variable definida ya existe.");}}
	        |DEFSTRING       VARIABLE    {if(!existe($2)){agregar (  $1, $2);}else{yyerror("La variable definida ya existe.");}}
	        |DEFBOOLEANO     VARIABLE    {if(!existe($2)){agregar (  $1, $2);}else{yyerror("La variable definida ya existe.");}}
	      	
expresion: expresion OPSUMA termino { $$ = $1 + $3;}
	   | expresion OPMENOS termino { $$ = $1 - $3;}
	   | termino  { $$ = $1;}

termino: termino OPMULT factor {$$ = $1*$3;}
	 | termino OPDIV factor {$$ = $1/$3;}
	 | factor  { $$ = $1;}

factor: DIGITO {$$ = $1;}
		|ENTERO   {$$ = $1;}
		|FLOTANTE  {$$ = $1;}
        |PAR_ABRE expresion PAR_CIERRA { $$ = $2;}






	  
%%

int main (){
	
	yyparse ();
	imprimirTabla();
	return 0;

}
