#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef char t_simbolo[50];

t_simbolo tablaDeSimbolos[2][50];
int fila = 0;

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
    int existe = 10;

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
