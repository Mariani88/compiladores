#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef char t_simbolo[50];

t_simbolo tablaDeSimbolos[50][2];
int fila = 0;


int esTipoNumero (t_simbolo tipo){

    int esNumero = 0;

    if (  (strcmp (tipo, "float") == 0) | (strcmp (tipo, "digit")== 0) | (strcmp (tipo, "int") == 0)  ){

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

    int existe = 10;
    int filaEscaneada = 0;

    while ( filaEscaneada < fila && existe != 1){

        if (strcmp (tablaDeSimbolos[filaEscaneada][1], variableIngresada ) == 0){
            existe = 1;
        }
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
