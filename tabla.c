#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "sintactico.tab.h"

extern int yyerror(const char *mensaje);

typedef char t_simbolo[50];

t_simbolo tablaDeSimbolos[50][2];
int fila = 0;


int esTipoNumero (t_simbolo tipo){

    int esNumero = 0;

    if (  (strcmp (tipo, "float") == 0) || (strcmp (tipo, "int") == 0)  ){

        esNumero = 1;
    }

    return esNumero;
}


void agregar ( t_simbolo tipoIngresado , t_simbolo variableIngresada){

    strcpy( tablaDeSimbolos[fila][0], tipoIngresado );
    strcpy( tablaDeSimbolos[fila][1], variableIngresada );

    printf( "agregado: %s %s \n",tablaDeSimbolos [fila][0], tablaDeSimbolos [fila][1] );
    fila++;
}

int existe (t_simbolo variableIngresada){

    int existe = 0;
    int filaEscaneada = 0;

    while ( filaEscaneada < fila && !existe){

        existe = strcmp (tablaDeSimbolos[filaEscaneada][1], variableIngresada ) == 0;
        filaEscaneada++;
    }

    return existe;
}


void tipoDe (t_simbolo variableIngresada, char*  tipo){

    int filaEscaneada = 0;
    int existe = 0;

     while ( filaEscaneada < fila && existe != 1){

        if (strcmp (tablaDeSimbolos[filaEscaneada][1], variableIngresada ) == 0){
            existe = 1;
            strcpy(tipo, tablaDeSimbolos[filaEscaneada][0]);
        }

        filaEscaneada++;
    }
}

void imprimirTabla (){

    int i = 0;

    for ( i = 0; i < fila; i++){
            printf ("%s %s \n", tablaDeSimbolos [i][0], tablaDeSimbolos[i][1]);
    }
}


int sonNumeros (t_simbolo variableIngresada, t_simbolo variableIngresada2){

    int sonNumeros = 0;
    t_simbolo tipo1;
    t_simbolo tipo2;

    tipoDe(variableIngresada, tipo1);
    tipoDe(variableIngresada2, tipo2);

    if ( esTipoNumero (tipo1) == 1 && esTipoNumero (tipo2) == 1 ){
        sonNumeros = 1;
    }

        return sonNumeros;
}

char* tipoResultanteDe (t_simbolo variableIngresada, t_simbolo variableIngresada2, t_simbolo operacion){

    t_simbolo tipo1, tipo2;

    tipoDe(variableIngresada, tipo1);
    tipoDe(variableIngresada2, tipo2);

    if (strcmp (tipo1, "float") == 0 || strcmp (tipo2, "float") == 0 || strcmp (operacion, "division") == 0){
        return "float";
    }else {
        return "int";
    }
}


int sonDelMismoTipo (t_simbolo variableIngresada, t_simbolo variableIngresada2){

    int mismoTipo = 0;
    t_simbolo tipo1, tipo2;

    tipoDe(variableIngresada, tipo1);
    tipoDe(variableIngresada2, tipo2);


    if ( strcmp (tipo1, tipo2) == 0 ){
        mismoTipo = 1;
    }

    return mismoTipo;
}

//Metodos agregados
void comprobarCaracter(t_simbolo variable){
    t_simbolo tipo;
    tipoDe(variable,tipo);
    int esChar = 0;
    esChar =(strcmp (tipo, "char") == 0);
    if(!esChar){
       yyerror("La variable debe ser de tipo char");
    }
}

void comprobarFlotante(t_simbolo variable){
    t_simbolo tipo;
    tipoDe(variable,tipo);
    int esFlotante = 0;
    esFlotante =(strcmp (tipo, "float") == 0);
    if(!esFlotante){
       yyerror("La variable debe ser de tipo float");
    }
}

void comprobarEntero(t_simbolo variable){
    t_simbolo tipo;
    tipoDe(variable,tipo);
    int esEntero = 0;
    esEntero =(strcmp (tipo, "int") == 0);
    if(!esEntero){
       yyerror("La variable debe ser de tipo int");
    }
}


void comprobarString(t_simbolo variable){
    t_simbolo tipo;
    tipoDe(variable, tipo);
    if(strcmp (tipo, "string") != 0){
        yyerror("La variable debe ser del tipo string.");
    }
}

void comprobarBoolean(t_simbolo variable){
    t_simbolo tipo;
    tipoDe(variable, tipo);
    if(strcmp (tipo, "boolean") != 0){
        yyerror("La variable debe ser del tipo boolean.");
    }    
}

void comprobarExistencia(t_simbolo variable){
    if(!existe(variable)){
        yyerror("Variable no definida.");
        }
}

void compararTipos(t_simbolo a,t_simbolo b){
    if(!sonDelMismoTipo(a,b)){
        yyerror("Tipos incompatibles");
    }    
}

int esFloat(t_simbolo a){
    int esFlotante = 0;
    t_simbolo tipo;
    tipoDe(a,tipo);
    esFlotante = (strcmp(tipo,"float")!=0);
    return esFlotante;
}

void comprobarVariasVariables(t_simbolo a, t_simbolo b ,t_simbolo c){
    t_simbolo tipo;
    if(!sonNumeros(a, b) || !sonNumeros(b,c)){
        yyerror("Esta operacion solo se puede aplicar a tipos de datos numericos.");
    }
    else if((!sonDelMismoTipo(a, b) || (!sonDelMismoTipo(b, c)))&& !esFloat(a)){
        yyerror("La variable a la cual asignar debe ser del tipo float.");
    }
}    

