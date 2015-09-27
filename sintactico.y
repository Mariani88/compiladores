%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
%}

%union {
char *cadena;
int numero;
}


%token OPDIV
%token OPMULT
%token PAR_CIERRA
%token PAR_ABRE
%token OPMENOS
%token OPSUMA
%token <numero> DIGITO

%type <numero> expresion
%type <numero> termino
%type <numero> factor

%%

expresion: expresion OPSUMA termino { $$ = $1 + $3;  printf ("resultado: %d\n", $$);}
	   | expresion OPMENOS termino { $$ = $1 - $3;}
	   | PAR_ABRE expresion PAR_CIERRA { $$ = $2;}
 	   | termino { $$ = $1;}; 

termino: expresion OPMULT DIGITO {$$ = $1*$3;}
	| expresion OPDIV DIGITO{$$ = $1/$3;}
	| DIGITO OPDIV expresion {$$ = $1/$3;}
	| expresion OPDIV expresion {$$ = $1/$3;}
	| DIGITO { $$ = $1;};
  	  
%%





yyerror (s)  
     char *s;
{
  printf ("%s\n", s);
}

void main (){
	
	yyparse ();

}
