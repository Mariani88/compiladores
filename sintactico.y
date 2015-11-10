%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include "tabla.c"

//Usado solo para revision de errores
#define YYDEBUG 1

#define HOJAENTERO 1
#define FACTOR 2
#define TERMINO 3
#define EXPRESIONFLOAT 4
#define DECLARACION 5
#define ASIGNACION 6
#define SUMAMIXTA 7
#define RESTAMIXTA 8
#define MULTIPLICACIONMIXTA 9
#define FACTORENTERO 10
#define TERMINOENTERO 11
#define EXPRESIONENTERA 12
#define EXPRESION 13
#define CONDICION 14
#define SENTENCIAIF 15
#define SENTENCIAWHILE 16
#define SENTENCIA 17
#define CUERPO 18
#define MAIN 19
#define HOJAVARIABLE 20
#define HOJAFLOTANTE 21
#define HOJASTRING 22
#define DIVISIONMIXTA 23


//-- Lexer prototype required by bison, aka getNextToken()
int yylex(); 
int yyerror(const char *mensaje) { printf("Error sintactico: %s\n",mensaje);}

typedef struct ast_node{
  char* operador;
  char* variable;
  int tipoNodo;
  int valorEntero;
  float valorFlotante;
  char* valorString;
  struct ast_node* central;  
  struct ast_node* left; 
  struct ast_node* right;

}ast_node;

struct ast_node* nuevo_nodo_expresion(int tipoNodo,char* operador, struct ast_node* right, struct ast_node* left){
    struct ast_node* nuevoNodo = (struct ast_node*) malloc(sizeof(struct ast_node));
    nuevoNodo->operador = (char*)malloc(sizeof(char)*2);
    strcpy(nuevoNodo->operador, operador);
    nuevoNodo->tipoNodo = tipoNodo;
    nuevoNodo->central = 0;
    nuevoNodo->right = right;
    nuevoNodo->left = left;
    return nuevoNodo;
}

struct ast_node* nuevo_nodo_if(struct ast_node* condicion,struct ast_node* central, struct ast_node* right){
    struct ast_node* nuevoNodo = (struct ast_node*) malloc(sizeof(struct ast_node));
    nuevoNodo->operador = 0;
    nuevoNodo->tipoNodo = IF;
    nuevoNodo->central = central ;
    nuevoNodo->right = right;
    nuevoNodo->left = condicion;
    return nuevoNodo;
}

struct ast_node* nuevo_nodo_entero(int valor){
    struct ast_node* nuevoNodo = (struct ast_node*) malloc(sizeof(struct ast_node));
    nuevoNodo->tipoNodo = HOJAENTERO;
    nuevoNodo->valorEntero = valor;
    nuevoNodo->right = 0;
    nuevoNodo->left = 0;
    return nuevoNodo;
}

struct ast_node* nuevo_nodo_variable(char* variable){
    struct ast_node* nuevoNodo = (struct ast_node*) malloc(sizeof(struct ast_node));
    nuevoNodo->tipoNodo = HOJAVARIABLE;
    nuevoNodo->variable = (char*)malloc(sizeof(char)*50);
    strcpy(nuevoNodo->variable, variable);
    nuevoNodo->right = 0;
    nuevoNodo->left = 0;
    return nuevoNodo;
}

struct ast_node* nuevo_nodo_flotante(float valor){
    struct ast_node* nuevoNodo = (struct ast_node*) malloc(sizeof(struct ast_node));
    nuevoNodo->tipoNodo = HOJAFLOTANTE;
    nuevoNodo->valorFlotante = valor;
    nuevoNodo->right = 0;
    nuevoNodo->left = 0;
    return nuevoNodo;
}

%}


%union {
    struct ast_node * ast;
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


%type <ast> asignacion expresion expresionFloat termino factor sumaMixta restaMixta multiplicacionMixta divisionMixta expresionMixta
 
%type <ast> expresionEntera declaracion sentencia sentencia_if cuerpo sentencia_while condicion terminoEntero factorEntero

%%

programa: MAIN LLAVEABRE cuerpo LLAVECIERRA;

cuerpo: sentencia cuerpo | sentencia

sentencia: declaracion| asignacion | expresionFloat | expresionEntera | sumaMixta | restaMixta | sentencia_if | sentencia_while

asignacion: VARIABLE IGUAL expresionFloat FINDELINEA {  
                                                        comprobarExistencia($1);
                                                        comprobarFlotante($1);
                                                        ast_node* hoja_variable = nuevo_nodo_variable($1);
                                                        $$ = nuevo_nodo_expresion(ASIGNACION,"=",hoja_variable,$3);
                                                      }
            | VARIABLE IGUAL expresionMixta FINDELINEA{
                                                        comprobarExistencia($1);comprobarFlotante($1);
                                                        ast_node* hoja_variable = nuevo_nodo_variable($1);
                                                        $$ = nuevo_nodo_expresion(ASIGNACION,"=",hoja_variable,$3);
                                                      }
            | VARIABLE IGUAL expresionEntera FINDELINEA{
                                                          comprobarExistencia($1);
                                                          comprobarEntero($1);
                                                          ast_node* hoja_variable = nuevo_nodo_variable($1);
                                                          $$ = nuevo_nodo_expresion(ASIGNACION,"=",hoja_variable,$3);
                                                       }
            | VARIABLE IGUAL VARIABLE FINDELINEA {  
                                                    ast_node* hoja_variable = nuevo_nodo_variable($1);
                                                    ast_node* v_dos = nuevo_nodo_variable($3);
                                                    if(!existe($1)|| !existe($3)){
                                                                                    yyerror("Variable no definida.");
                                                                                 } 
                                                    $$ = nuevo_nodo_expresion(ASIGNACION,"=",hoja_variable,v_dos);
                                                    compararTipos($1,$3);
                                                 }
            | VARIABLE IGUAL VARIABLE OPSUMA VARIABLE FINDELINEA {
                                                                       if(!existe($1)||!existe($3)||!existe($5)){
                                                                            yyerror("Variable no definida.");
                                                                       }
                                                                       compararTipos($1,$3);
                                                                       compararTipos($1,$5);
                                                                       comprobarVariasVariables($1,$3,$5);
                                                                       ast_node* hoja_variable = nuevo_nodo_variable($1);
                                                                       ast_node* v_dos = nuevo_nodo_variable($3);
                                                                       ast_node* v_tres = nuevo_nodo_variable($5);
                                                                       ast_node* suma = nuevo_nodo_expresion(EXPRESION,"+",v_dos,v_tres);
                                                                       $$ = nuevo_nodo_expresion(ASIGNACION,"",hoja_variable,suma);
                                                                    }
            | VARIABLE IGUAL CARACTER FINDELINEA {comprobarExistencia($1);comprobarCaracter($1);}
            | VARIABLE IGUAL STRING   FINDELINEA {comprobarExistencia($1);comprobarString($1);}
            | VARIABLE IGUAL BOOLEANO FINDELINEA {comprobarExistencia($1);comprobarBoolean($1);}

            
declaracion: DEFENTERO  VARIABLE  FINDELINEA  {   
                                               ast_node* variable = nuevo_nodo_variable($2);
                                               $$ = nuevo_nodo_expresion(DECLARACION,"",0,variable);
                                               if(!existe($2)){agregar (  $1, $2);}else{yyerror("La variable definida ya existe.");}}
             | DEFFLOTANTE  VARIABLE  FINDELINEA  {
                                                       ast_node* variable = nuevo_nodo_variable($2);
                                                       $$ = nuevo_nodo_expresion(DECLARACION,"",0,variable);
                                                       if(!existe($2)){agregar (  $1, $2);}else{yyerror("La variable definida ya existe.");}}
             | DEFCHAR VARIABLE FINDELINEA  {
                                              ast_node* variable = nuevo_nodo_variable($2);
                                              $$ = nuevo_nodo_expresion(DECLARACION,"",0,variable);
                                              if(!existe($2)){agregar (  $1, $2);}else{yyerror("La variable definida ya existe.");}
                                            }
             | DEFCONSTANTE  VARIABLE  FINDELINEA  {
                                                       ast_node* variable = nuevo_nodo_variable($2);
                                                       $$ = nuevo_nodo_expresion(DECLARACION,"",0,variable);
                                                       if(!existe($2)){agregar (  $1, $2);}else{yyerror("La variable definida ya existe.");
                                                       }
                                                     }
             | DEFSTRING  VARIABLE  FINDELINEA {
                                                       ast_node* variable = nuevo_nodo_variable($2);
                                                       $$ = nuevo_nodo_expresion(DECLARACION,"",0,variable);
                                                       if(!existe($2)){agregar (  $1, $2);}else{yyerror("La variable definida ya existe.");}
                                               }
             | DEFBOOLEANO  VARIABLE  FINDELINEA {
                                                       ast_node* variable = nuevo_nodo_variable($2);
                                                       $$ = nuevo_nodo_expresion(DECLARACION,"",0,variable);
                                                       if(!existe($2)){agregar (  $1, $2);}else{yyerror("La variable definida ya existe.");}
                                                 }
 
 
expresionFloat: expresionFloat OPSUMA termino { $$ = nuevo_nodo_expresion(EXPRESIONFLOAT,"+",$1,$3);}
       | expresionFloat OPMENOS termino { $$ = nuevo_nodo_expresion(TERMINO,"-",$1,$3);}
       | termino  { $$ = $1;}   

expresionMixta: sumaMixta {$$ = $1;}
                | restaMixta {$$ = $1;}
                | multiplicacionMixta {$$ = $1;}
                | divisionMixta {$$ = $1;}
       
sumaMixta: expresionEntera  OPSUMA expresionFloat {$$ = nuevo_nodo_expresion(SUMAMIXTA,"+",$1,$3);}
           | expresionFloat OPSUMA expresionEntera {$$ = nuevo_nodo_expresion(SUMAMIXTA,"+",$1,$3);}                

multiplicacionMixta: termino OPMULT terminoEntero {$$ = nuevo_nodo_expresion(MULTIPLICACIONMIXTA,"*",$1,$3);}
                    | terminoEntero OPMULT termino {$$ = nuevo_nodo_expresion(MULTIPLICACIONMIXTA,"*",$1,$3);}
 
divisionMixta:  termino OPDIV terminoEntero {$$ = nuevo_nodo_expresion(DIVISIONMIXTA,"/",$1,$3);;}
                | terminoEntero OPDIV termino {$$ = nuevo_nodo_expresion(DIVISIONMIXTA,"/",$1,$3);;}     
                
restaMixta: expresionEntera OPMENOS expresionFloat {$$ = nuevo_nodo_expresion(RESTAMIXTA,"-",$1,$3);}
            | expresionFloat OPMENOS expresionEntera {$$ = nuevo_nodo_expresion(RESTAMIXTA,"-",$1,$3);}        
                                                   
                   
termino: termino OPMULT factor {$$ = nuevo_nodo_expresion(TERMINO,"*",$1,$3);}
     | termino OPDIV factor {$$ = nuevo_nodo_expresion(TERMINO,"/",$1,$3);}
     | factor  { $$ = $1;} 
     
factor: FLOTANTE {$$ = nuevo_nodo_flotante($1);}
        | PAR_ABRE expresionFloat PAR_CIERRA { 
                                              struct ast_node* vacio = 0;
                                              $$ = nuevo_nodo_expresion(FACTOR ,"+", vacio , $2);
                                            }

expresionEntera: expresionEntera OPSUMA terminoEntero {$$ = nuevo_nodo_expresion(EXPRESIONENTERA,"+",$1,$3);}
                | expresionEntera OPMENOS terminoEntero { $$ = nuevo_nodo_expresion(EXPRESIONENTERA,"-",$1,$3);}
                | terminoEntero  { $$ = $1;}
 
terminoEntero: terminoEntero OPMULT factorEntero {$$ = nuevo_nodo_expresion(TERMINOENTERO,"*",$1,$3);} 
     | terminoEntero OPDIV factorEntero {$$ = nuevo_nodo_expresion(TERMINOENTERO,"*",$1,$3);}
     | factorEntero  { $$ = $1;} 

factorEntero: ENTERO{$$ = nuevo_nodo_entero($1);}
              |PAR_ABRE expresionEntera PAR_CIERRA { $$ = nuevo_nodo_expresion(FACTORENTERO," ",0,$2);}    
 
sentencia_if:   IF PAR_ABRE condicion PAR_CIERRA LLAVEABRE cuerpo LLAVECIERRA {$$ = nuevo_nodo_expresion(IF,"",$3,$6);}
                | IF PAR_ABRE condicion PAR_CIERRA LLAVEABRE cuerpo LLAVECIERRA ELSE LLAVEABRE cuerpo LLAVECIERRA {
                        $$ = nuevo_nodo_if($3,$6,$10);
                }
                
sentencia_while:
                 WHILE PAR_ABRE condicion PAR_CIERRA LLAVEABRE cuerpo LLAVECIERRA {$$ = nuevo_nodo_expresion(WHILE,"",$3,$6);}
                
expresion: expresionEntera {$$ = nuevo_nodo_expresion(EXPRESION," ",0,$1);}
           | expresionFloat {$$ = nuevo_nodo_expresion(EXPRESION," ",0,$1);}
           | expresionMixta {$$ = nuevo_nodo_expresion(EXPRESION," ",0,$1);}

condicion:      expresion AND expresion {$$ = nuevo_nodo_expresion(CONDICION,"&&",$1,$3);}
                | expresion OR expresion {$$ = nuevo_nodo_expresion(CONDICION,"||",$1,$3);}
                | expresion DISTINTO expresion {$$ = nuevo_nodo_expresion(CONDICION,"&&",$1,$3);}
                | expresion COMPIGUAL expresion {$$ = nuevo_nodo_expresion(CONDICION,"==",$1,$3);}
                | expresion MAYOR expresion {$$ = nuevo_nodo_expresion(CONDICION,">",$1,$3);}
                | expresion MENOR expresion {$$ = nuevo_nodo_expresion(CONDICION,"<",$1,$3);}
                | expresion MAYORIGUAL expresion {$$ = nuevo_nodo_expresion(CONDICION,">=",$1,$3);}
                | expresion MENORIGUAL expresion {$$ = nuevo_nodo_expresion(CONDICION,"<=",$1,$3);}
                | expresion AND VARIABLE {
                                            ast_node* variable = nuevo_nodo_variable($3);
                                            $$ = nuevo_nodo_expresion(CONDICION,"&&",$1,variable);
                                         }
                | expresion OR VARIABLE {
                                            ast_node* variable = nuevo_nodo_variable($3);
                                            $$ = nuevo_nodo_expresion(CONDICION,"&&",$1,variable);
                                        }
                | expresion DISTINTO VARIABLE {
                                                ast_node* variable = nuevo_nodo_variable($3);
                                                $$ = nuevo_nodo_expresion(CONDICION,"!=",$1,variable);
                                              }
                | expresion COMPIGUAL VARIABLE {
                                                ast_node* variable = nuevo_nodo_variable($3);
                                                $$ = nuevo_nodo_expresion(CONDICION,"==",$1,variable);
                                               }
                | expresion MAYOR VARIABLE {
                                                ast_node* variable = nuevo_nodo_variable($3);
                                                $$ = nuevo_nodo_expresion(CONDICION,">",$1,variable);
                                           }
                | expresion MENOR VARIABLE {
                                                ast_node* variable = nuevo_nodo_variable($3);
                                                $$ = nuevo_nodo_expresion(CONDICION,"<",$1,variable);
                                           }
                | expresion MAYORIGUAL VARIABLE {
                                                    ast_node* variable = nuevo_nodo_variable($3);
                                                    $$ = nuevo_nodo_expresion(CONDICION,">=",$1,variable);
                                                }
                | expresion MENORIGUAL VARIABLE {
                                                    ast_node* variable = nuevo_nodo_variable($3);
                                                    $$ = nuevo_nodo_expresion(CONDICION,"<",$1,variable);
                                                }
                | VARIABLE AND expresion {
                                           ast_node* variable = nuevo_nodo_variable($1);
                                           $$ = nuevo_nodo_expresion(CONDICION,"&&",variable,$3);
                                         }
                | VARIABLE OR expresion {
                                           ast_node* variable = nuevo_nodo_variable($1);
                                           $$ = nuevo_nodo_expresion(CONDICION,"||",variable,$3);
                                        }
                | VARIABLE DISTINTO expresion {
                                                ast_node* variable = nuevo_nodo_variable($1);
                                                $$ = nuevo_nodo_expresion(CONDICION,"!=",variable,$3);
                                              }
                | VARIABLE COMPIGUAL expresion {
                                                    ast_node* variable = nuevo_nodo_variable($1);
                                                    $$ = nuevo_nodo_expresion(CONDICION,"==",variable,$3);
                                               }
                | VARIABLE MAYOR expresion {
                                              ast_node* variable = nuevo_nodo_variable($1);
                                              $$ = nuevo_nodo_expresion(CONDICION,">",variable,$3);
                                           }
                | VARIABLE MENOR expresion {
                                              ast_node* variable = nuevo_nodo_variable($1);
                                              $$ = nuevo_nodo_expresion(CONDICION,"<",variable,$3);
                                           }
                | VARIABLE MAYORIGUAL expresion {
                                                    ast_node* variable = nuevo_nodo_variable($1);
                                                    $$ = nuevo_nodo_expresion(CONDICION,">=",variable,$3);
                                                }
                | VARIABLE MENORIGUAL expresion {
                                                    ast_node* variable = nuevo_nodo_variable($1);
                                                    $$ = nuevo_nodo_expresion(CONDICION,"<=",variable,$3);
                                                }
                | VARIABLE AND VARIABLE {   
                                            ast_node* variable = nuevo_nodo_variable($1);
                                            ast_node* v_dos = nuevo_nodo_variable($3);
                                            $$ = nuevo_nodo_expresion(CONDICION,"&&",variable,v_dos);
                                        }
                | VARIABLE OR VARIABLE {
                                            ast_node* variable = nuevo_nodo_variable($1);
                                            ast_node* v_dos = nuevo_nodo_variable($3);
                                            $$ = nuevo_nodo_expresion(CONDICION,"||",variable,v_dos);
                                        }
                | VARIABLE DISTINTO VARIABLE {  
                                                ast_node* variable = nuevo_nodo_variable($1);
                                                ast_node* v_dos = nuevo_nodo_variable($3);$$ = nuevo_nodo_expresion(CONDICION,"!=",variable,v_dos);
                                             }
                | VARIABLE COMPIGUAL VARIABLE {
                                                ast_node* variable = nuevo_nodo_variable($1);
                                                ast_node* v_dos = nuevo_nodo_variable($3);
                                                $$ = nuevo_nodo_expresion(CONDICION,"==",variable,v_dos);
                                              }
                | VARIABLE MAYOR VARIABLE {
                                            ast_node* variable = nuevo_nodo_variable($1);
                                            ast_node* v_dos = nuevo_nodo_variable($3);
                                            $$ = nuevo_nodo_expresion(CONDICION,">",variable,v_dos);
                                          }
                | VARIABLE MENOR VARIABLE {
                                            ast_node* variable = nuevo_nodo_variable($1);
                                            ast_node* v_dos = nuevo_nodo_variable($3);
                                            $$ = nuevo_nodo_expresion(CONDICION,"<",variable,v_dos);
                                          }
                | VARIABLE MAYORIGUAL VARIABLE {
                                                  ast_node* variable = nuevo_nodo_variable($1);
                                                  ast_node* v_dos = nuevo_nodo_variable($3);
                                                  $$ = nuevo_nodo_expresion(CONDICION,">=",variable,v_dos);
                                               }
                | VARIABLE MENORIGUAL VARIABLE  {
                                                    ast_node* variable = nuevo_nodo_variable($1);
                                                    ast_node* v_dos = nuevo_nodo_variable($3);
                                                    $$ = nuevo_nodo_expresion(CONDICION,"<=",variable,v_dos);
                                                }              
                ;
                
%%

int main (){
    
    yyparse ();
    imprimirTabla();
    return 0;

}
