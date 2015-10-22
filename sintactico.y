%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

//-- Lexer prototype required by bison, aka getNextToken()
int yylex(); 
int yyerror(const char *p) { printf("error");}
%}

%union {
char cadena;
int numero;
}


%token <cadena> OPDIV OPMULT PAR_CIERRA PAR_ABRE OPMENOS OPSUMA findelinea
%token <numero> DIGITO
%type <numero> run expresion termino res factor

%%

run: res run | res 

res: expresion findelinea    {printf ("resultado: %d\n", $1);}

expresion: expresion OPSUMA termino { $$ = $1 + $3; printf ("regla1\n");}
	   | expresion OPMENOS termino { $$ = $1 - $3;printf ("regla2\n");}
	   | termino  { $$ = $1;printf ("regla3\n");}

termino: termino OPMULT factor {$$ = $1*$3;printf ("regla4\n");}
	 | termino OPDIV factor {$$ = $1/$3;printf ("regla5\n");}
	 | factor  { $$ = $1;printf ("regla6\n");}

factor: DIGITO {$$ = $1;printf ("regla7\n");}
	| PAR_ABRE expresion PAR_CIERRA { $$ = $2;printf ("regla8\n");}

  	  
%%

int main (){
	
	yyparse ();
	return 0;

}
