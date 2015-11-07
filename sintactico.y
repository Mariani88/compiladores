%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "tabla.c"

//Usado solo para revision de errores
#define YYDEBUG 1

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
%right ELSE
%token FOR
%token WHILE
%token <variable>CARACTER
%token BOOLEANO
%token <variable>VARIABLE
%token <variable>STRING

%token <numero> ENTERO
%token <flotante> FLOTANTE


%type <flotante> expresionFloat termino factor sumaMixta restaMixta multiplicacionMixta divisionMixta expresionMixta
 
%type <numero> expresionEntera terminoEntero factorEntero

%%

programa: MAIN LLAVEABRE cuerpo LLAVECIERRA;

cuerpo: sentencia cuerpo | sentencia

sentencia: declaracion| asignacion | expresionFloat | expresionEntera | sumaMixta | restaMixta | sentencia_if | sentencia_while

operacion: OPSUMA
           | OPMENOS
           | OPMULT
           | OPDIV

asignacion: VARIABLE IGUAL expresionFloat FINDELINEA {comprobarExistencia($1);comprobarFlotante($1);}
            | VARIABLE IGUAL expresionMixta FINDELINEA{comprobarExistencia($1);comprobarFlotante($1);}
            | VARIABLE IGUAL expresionEntera FINDELINEA{comprobarExistencia($1);comprobarEntero($1);}
            | VARIABLE IGUAL VARIABLE FINDELINEA {if(!existe($1)|| !existe($3)){yyerror("Variable no definida.");}compararTipos($1,$3);}
            | VARIABLE IGUAL VARIABLE operacion VARIABLE FINDELINEA {if(!existe($1)|| !existe($3)|| !existe($5)){yyerror("Variable no definida.");}compararTipos($1,$3);compararTipos($1,$5);comprobarVariasVariables($1,$3,$5);}
            | VARIABLE IGUAL CARACTER FINDELINEA {comprobarExistencia($1);comprobarCaracter($1);}
            | VARIABLE IGUAL STRING   FINDELINEA {comprobarExistencia($1);comprobarString($1);}
            | VARIABLE IGUAL BOOLEANO FINDELINEA {comprobarExistencia($1);comprobarBoolean($1);}

declaracion: DEFENTERO        VARIABLE  FINDELINEA  {if(!existe($2)){agregar (  $1, $2);}else{yyerror("La variable definida ya existe.");}}
             |DEFFLOTANTE     VARIABLE  FINDELINEA  {if(!existe($2)){agregar (  $1, $2);}else{yyerror("La variable definida ya existe.");}}
             |DEFCHAR         VARIABLE  FINDELINEA  {if(!existe($2)){agregar (  $1, $2);}else{yyerror("La variable definida ya existe.");}}
             |DEFCONSTANTE    VARIABLE  FINDELINEA  {if(!existe($2)){agregar (  $1, $2);}else{yyerror("La variable definida ya existe.");}}
             |DEFSTRING       VARIABLE   FINDELINEA {if(!existe($2)){agregar (  $1, $2);}else{yyerror("La variable definida ya existe.");}}
             |DEFBOOLEANO     VARIABLE   FINDELINEA {if(!existe($2)){agregar (  $1, $2);}else{yyerror("La variable definida ya existe.");}}
                        
expresionFloat: expresionFloat OPSUMA termino { $$ = $1 + $3;}
       | expresionFloat OPMENOS termino { $$ = $1 - $3;}
       | termino  { $$ = $1;}   

expresionMixta: sumaMixta {$$ = $1;}
                | restaMixta {$$ = $1;}
                | multiplicacionMixta {$$ = $1;}
                | divisionMixta {$$ = $1;}
       
sumaMixta: expresionEntera  OPSUMA expresionFloat {$$ = $1 + $3;}
           | expresionFloat OPSUMA expresionEntera {$$ = $1 + $3;}                

multiplicacionMixta: termino OPMULT terminoEntero {$$ = $1*$3;}
                    | terminoEntero OPMULT termino {$$ = $1*$3;}
 
divisionMixta:  termino OPDIV terminoEntero {$$ = $1/$3;}
                | terminoEntero OPDIV termino {$$ = $1/$3;}     
                
restaMixta: expresionEntera OPMENOS expresionFloat {$$ = $1 - $3;}
            | expresionFloat OPMENOS expresionEntera {$$ = $1 - $3;}        
                                                   
                   
termino: termino OPMULT factor {$$ = $1*$3;}
     | termino OPDIV factor {$$ = $1/$3;}
     | factor  { $$ = $1;} 
     
factor: FLOTANTE {$$ = $1;}
        |PAR_ABRE expresionFloat PAR_CIERRA { $$ = $2;}

expresionEntera: expresionEntera OPSUMA terminoEntero {$$ = $1 + $3;}
                | expresionEntera OPMENOS terminoEntero { $$ = $1 - $3;}
                | terminoEntero  { $$ = $1;}
 
terminoEntero: terminoEntero OPMULT factorEntero {$$ = $1*$3;} 
     | terminoEntero OPDIV factorEntero {$$ = $1/$3;}
     | factorEntero  { $$ = $1;} 

factorEntero: ENTERO{$$ = $1;}
              |PAR_ABRE expresionEntera PAR_CIERRA { $$ = $2;}    
 
sentencia_if:   IF PAR_ABRE condicion PAR_CIERRA LLAVEABRE cuerpo LLAVECIERRA
                | IF PAR_ABRE condicion PAR_CIERRA LLAVEABRE cuerpo LLAVECIERRA ELSE LLAVEABRE cuerpo LLAVECIERRA
                
sentencia_while:
                 WHILE PAR_ABRE condicion PAR_CIERRA LLAVEABRE cuerpo LLAVECIERRA
                
expresion: expresionEntera
           | expresionFloat
           | expresionMixta

condicion:      expresion AND expresion
                | expresion OR expresion
                | expresion DISTINTO expresion
                | expresion COMPIGUAL expresion
                | expresion MAYOR expresion
                | expresion MENOR expresion
                | expresion MAYORIGUAL expresion
                | expresion MENORIGUAL expresion
                | expresion AND VARIABLE
                | expresion OR VARIABLE
                | expresion DISTINTO VARIABLE
                | expresion COMPIGUAL VARIABLE
                | expresion MAYOR VARIABLE
                | expresion MENOR VARIABLE
                | expresion MAYORIGUAL VARIABLE
                | expresion MENORIGUAL VARIABLE
                | VARIABLE AND expresion
                | VARIABLE OR expresion
                | VARIABLE DISTINTO expresion
                | VARIABLE COMPIGUAL expresion
                | VARIABLE MAYOR expresion
                | VARIABLE MENOR expresion
                | VARIABLE MAYORIGUAL expresion
                | VARIABLE MENORIGUAL expresion
                | VARIABLE AND VARIABLE
                | VARIABLE OR VARIABLE
                | VARIABLE DISTINTO VARIABLE
                | VARIABLE COMPIGUAL VARIABLE
                | VARIABLE MAYOR VARIABLE
                | VARIABLE MENOR VARIABLE
                | VARIABLE MAYORIGUAL VARIABLE
                | VARIABLE MENORIGUAL VARIABLE              
                ;
                
%%

int main (){
    
    yyparse ();
    imprimirTabla();
    return 0;

}
