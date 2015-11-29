#ifndef ARBOL_C
#define ARBOL_C

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include "tabla.c"

#define MAIN 1
#define CUERPO 2
#define DECLARACION 3
#define ASIGNACION 4
#define CONDICION 5
#define SENTENCIA_IF 6
#define SENTENCIA_WHILE 7
#define SENTENCIA 8
#define SUMA_MIXTA 9
#define RESTA_MIXTA 10
#define MULTIPLICACION_MIXTA 11
#define DIVISION_MIXTA 12
#define FACTOR_ENTERO 13
#define TERMINO_ENTERO 14
#define EXPRESION_ENTERA 15
#define FACTOR_FLOAT 16
#define TERMINO_FLOAT 17
#define EXPRESION_FLOAT 18
#define EXPRESION 19
#define HOJA_ENTERO 20
#define HOJA_FLOTANTE 21
#define HOJA_CARACTER 22
#define HOJA_STRING 23
#define HOJA_BOOLEAN 24
#define HOJA_VARIABLE 25

static int contadorDeEtiquetasTrue = 1;
static int contadorDeEtiquetasFalse = 1;

typedef struct nodo_as
{
    char* operador;
    char* variable;
    int tipoNodo;
    int valorEntero;
    char* valorCaracter;
    float valorFlotante;
    char* valorString;
    char* valorBoolean;
    struct nodo_as* left;
    struct nodo_as* central;
    struct nodo_as* right;
} nodo_as;

/* Utilizado para comprobar el tipo de nodo de cada arbol. */
void imprimirTipoDeNodo(nodo_as* arbol)
{
    switch (arbol->tipoNodo)
    {

    case MAIN:
        printf("Nodo main\n");
        break;

    case CUERPO:
        printf("Nodo cuerpo\n");
        break;

    case SENTENCIA:
        printf("Nodo sentencia\n");
        break;

    case CONDICION:
        printf("Nodo condicion\n");
        break;

    case SENTENCIA_IF:
        printf("Nodo if\n");
        break;

    case SENTENCIA_WHILE:
        printf("Nodo while\n");
        break;

    case DECLARACION:
        printf("Nodo declaracion\n");
        break;

    case ASIGNACION:
        printf("Nodo asignacion\n");
        break;

    case TERMINO_ENTERO:
        printf("Nodo termino entero\n");
        break;

    case FACTOR_ENTERO:
        printf("Nodo factor entero\n");
        break;

    case TERMINO_FLOAT:
        printf("Nodo termino float\n");
        break;

    case FACTOR_FLOAT:
        printf("Nodo factor float\n");
        break;

    case HOJA_ENTERO:
        printf("Nodo entero\n");
        break;

    case HOJA_FLOTANTE:
        printf("Nodo flotante\n");
        break;

    case HOJA_STRING:
        printf("Nodo string\n");
        break;

    case HOJA_CARACTER:
        printf("Nodo caracter\n");
        break;

    case HOJA_BOOLEAN:
        printf("Nodo boolean\n");
        break;

    case HOJA_VARIABLE:
        printf("Nodo variable\n");
        break;

    case SUMA_MIXTA:
        printf("Nodo suma mixta\n");
        break;

    case RESTA_MIXTA:
        printf("Nodo resta mixta\n");
        break;

    case MULTIPLICACION_MIXTA:
        printf("Nodo multiplicacion mixta\n");
        break;

    case DIVISION_MIXTA:
        printf("Nodo division mixta\n");
        break;

    default:
        printf("DESCONOCIDO\n");
        break;
    }
}

/* Usado sólo para comprobar la construccion del arbol */
void mostrarArbol(struct nodo_as* arbol)
{
    if (arbol == NULL )
        return;
    imprimirTipoDeNodo(arbol);
    mostrarArbol(arbol->left);
    mostrarArbol(arbol->right);
}

/* Escribe en un fichero los datos del nodo que se está recorriendo. Se incluye la impresion por consola de nodos irrelevantes sólo para comprobar que el arbol no los contenga. */
void escribirValorDeNodo(FILE* archivo,nodo_as* arbol)
{
    switch (arbol->tipoNodo)
    {
    case HOJA_ENTERO:
        archivo = fopen("codigoIntermedio.txt", "a");
        if (archivo == NULL)
        {
            perror ("Error al abrir el fichero\n");
        }
        fprintf(archivo," %d ",arbol->valorEntero);
        fclose(archivo);
        break;

    case FACTOR_FLOAT:
        printf("Nodo factor float\n");
        break;

    case TERMINO_FLOAT:
        printf("Nodo termino float\n");
        break;

    case EXPRESION_FLOAT:
        archivo = fopen("codigoIntermedio.txt", "a");
        if (archivo == NULL)
        {
            perror ("Error al abrir el fichero\n");
        }
        fprintf(archivo,"+");
        fclose(archivo);
        printf("Nodo expresion entera\n");
        break;

    case DECLARACION:
        printf("Nodo declaracion\n");
        break;

    case ASIGNACION:
        archivo = fopen("codigoIntermedio.txt", "a");
        if (archivo == NULL)
        {
            perror ("Error al abrir el fichero\n");
        }
        fprintf(archivo,"= \n");
        fclose(archivo);
        break;

    case SUMA_MIXTA:
        archivo = fopen("codigoIntermedio.txt", "a");
        if (archivo == NULL)
        {
            perror ("Error al abrir el fichero\n");
        }
        fprintf(archivo,"+");
        fclose(archivo);
        break;

    case RESTA_MIXTA:
        archivo = fopen("codigoIntermedio.txt", "a");
        if (archivo == NULL)
        {
            perror ("Error al abrir el fichero\n");
        }
        fprintf(archivo,"-");
        fclose(archivo);
        break;

    case MULTIPLICACION_MIXTA:
        archivo = fopen("codigoIntermedio.txt", "a");
        if (archivo == NULL)
        {
            perror ("Error al abrir el fichero\n");
        }
        fprintf(archivo,"*");
        fclose(archivo);
        break;

    case FACTOR_ENTERO:
        printf("Nodo factor entero\n");
        break;

    case TERMINO_ENTERO:
        archivo = fopen("codigoIntermedio.txt", "a");
        if (archivo == NULL)
        {
            perror ("Error al abrir el fichero\n");
        }
        fprintf(archivo,"*");
        fclose(archivo);
        break;

    case EXPRESION_ENTERA:
        archivo = fopen("codigoIntermedio.txt", "a");
        if (archivo == NULL)
        {
            perror ("Error al abrir el fichero\n");
        }
        fprintf(archivo,"%s",arbol->operador);
        fclose(archivo);
        printf("Nodo expresion entera\n");
        break;

    case EXPRESION:
        archivo = fopen("codigoIntermedio.txt", "a");
        if (archivo == NULL)
        {
            perror ("Error al abrir el fichero\n");
        }
        fprintf(archivo,"%s",arbol->operador);
        fclose(archivo);
        printf("Nodo expresion\n");
        break;

    case CONDICION:
        archivo = fopen("codigoIntermedio.txt", "a");
        if (archivo == NULL)
        {
            perror ("Error al abrir el fichero\n");
        }
        fprintf(archivo,"%s goto labelTrue%d \n",arbol->operador,contadorDeEtiquetasTrue);
        fprintf(archivo,"%s%d","labelTrue",contadorDeEtiquetasTrue);
        contadorDeEtiquetasTrue++;
        fclose(archivo);
        break;

    case SENTENCIA:
        printf("Nodo sentencia\n");
        break;

    case CUERPO:
        printf("Nodo cuerpo\n");
        break;

    case MAIN:
        printf("Nodo main\n");
        break;

    case HOJA_VARIABLE:
        archivo = fopen("codigoIntermedio.txt", "a");
        if (archivo == NULL)
        {
            perror ("Error al abrir el fichero\n");
        }
        fprintf(archivo," %s ",arbol->variable);
        fclose(archivo);
        break;

    case HOJA_FLOTANTE:
        archivo = fopen("codigoIntermedio.txt", "a");
        if (archivo == NULL)
        {
            perror ("Error al abrir el fichero\n");
        }
        fprintf(archivo,"%f",arbol->valorFlotante);
        fclose(archivo);
        break;

    case DIVISION_MIXTA:
        archivo = fopen("codigoIntermedio.txt", "a");
        if (archivo == NULL)
        {
            perror ("Error al abrir el fichero\n");
        }
        fprintf(archivo,"/");
        fclose(archivo);
        break;

    case HOJA_CARACTER:
        archivo = fopen("codigoIntermedio.txt", "a");
        if (archivo == NULL)
        {
            perror ("Error al abrir el fichero\n");
        }
        fprintf(archivo,"%s",arbol->valorCaracter);
        fclose(archivo);
        break;

    case HOJA_STRING:
        archivo = fopen("codigoIntermedio.txt", "a");
        if (archivo == NULL)
        {
            perror ("Error al abrir el fichero\n");
        }
        fprintf(archivo,"%s",arbol->valorString);
        fclose(archivo);
        break;

    case HOJA_BOOLEAN:
        archivo = fopen("codigoIntermedio.txt", "a");
        if (archivo == NULL)
        {
            perror ("Error al abrir el fichero\n");
        }
        fprintf(archivo,"%s",arbol->valorBoolean);
        fclose(archivo);
        break;

    default:
        archivo = fopen("F:\codigoIntermedio.txt", "a");
        fprintf(archivo,"DESCONOCIDO\n");
        fclose(archivo);
        break;
    }
}

void imprimirArchivo(nodo_as* arbol)
{
    if (arbol == NULL )
    {
        return;
    }
    FILE* archivo;
    if(arbol->tipoNodo == SENTENCIA_IF)
    {
        archivo = fopen("codigoIntermedio.txt","a");
        fprintf(archivo,"IF");
        fclose(archivo);
        imprimirArchivo(arbol->left);
        escribirValorDeNodo(archivo,arbol);
        if(arbol->central != NULL)
        {
            imprimirArchivo(arbol->central);
            archivo = fopen("codigoIntermedio.txt","a");
            fprintf(archivo,"labelFalse%d",contadorDeEtiquetasFalse);
            contadorDeEtiquetasFalse++;
            fclose(archivo);
        }
        imprimirArchivo(arbol->right);
    }
    else
    {
        if(arbol->tipoNodo == SENTENCIA_WHILE)
        {
            archivo = fopen("codigoIntermedio.txt","a");
            fprintf(archivo,"WHILE");
            fclose(archivo);
        }
        imprimirArchivo(arbol->left);
        imprimirArchivo(arbol->right);
        escribirValorDeNodo(archivo,arbol);
    }
}

struct nodo_as* nuevo_nodo_expresion(int tipoNodo, char* operador,
                                     struct nodo_as* left, struct nodo_as* right)
{
    struct nodo_as* nuevoNodo = (struct nodo_as*) malloc(sizeof(struct nodo_as));
    nuevoNodo->operador = (char*) malloc(sizeof(char) * 2);
    strcpy(nuevoNodo->operador, operador);
    nuevoNodo->tipoNodo = tipoNodo;
    nuevoNodo->central = 0;
    nuevoNodo->right = right;
    nuevoNodo->left = left;
    return nuevoNodo;
}

struct nodo_as* nuevo_nodo_if(struct nodo_as* condicion,
                              struct nodo_as* central, struct nodo_as* right)
{
    struct nodo_as* nuevoNodo = (struct nodo_as*) malloc(sizeof(struct nodo_as));
    nuevoNodo->operador = 0;
    nuevoNodo->tipoNodo = SENTENCIA_IF;
    nuevoNodo->left = condicion;
    nuevoNodo->central = central;
    nuevoNodo->right = right;
    return nuevoNodo;
}

struct nodo_as* nuevo_nodo_while(struct nodo_as* condicion, struct nodo_as* cuerpo)
{
    struct nodo_as* nuevoNodo = (struct nodo_as*) malloc(sizeof(struct nodo_as));
    nuevoNodo->operador = 0;
    nuevoNodo->tipoNodo = SENTENCIA_WHILE;
    nuevoNodo->left = condicion;
    nuevoNodo->central = 0;
    nuevoNodo->right = cuerpo;
    return nuevoNodo;
}

struct nodo_as* nuevo_nodo_entero(int valor)
{
    struct nodo_as* nuevoNodo = (struct nodo_as*) malloc(sizeof(struct nodo_as));
    nuevoNodo->tipoNodo = HOJA_ENTERO;
    nuevoNodo->valorEntero = valor;
    nuevoNodo->right = 0;
    nuevoNodo->left = 0;
    nuevoNodo->central = 0;
    return nuevoNodo;
}

struct nodo_as* nuevo_nodo_variable(char* variable)
{
    struct nodo_as* nuevoNodo = (struct nodo_as*) malloc(sizeof(struct nodo_as));
    nuevoNodo->tipoNodo = HOJA_VARIABLE;
    nuevoNodo->variable = (char*) malloc(sizeof(char) * 50);
    strcpy(nuevoNodo->variable, variable);
    nuevoNodo->central = 0;
    nuevoNodo->right = 0;
    nuevoNodo->left = 0;
    return nuevoNodo;
}

struct nodo_as* nuevo_nodo_flotante(float valor)
{
    struct nodo_as* nuevoNodo = (struct nodo_as*) malloc(sizeof(struct nodo_as));
    nuevoNodo->tipoNodo = HOJA_FLOTANTE;
    nuevoNodo->valorFlotante = valor;
    nuevoNodo->right = 0;
    nuevoNodo->left = 0;
    return nuevoNodo;
}

struct nodo_as* nuevo_nodo_caracter(char* caracter)
{
    struct nodo_as* nuevoNodo = (struct nodo_as*) malloc(sizeof(struct nodo_as));
    nuevoNodo->tipoNodo = HOJA_CARACTER;
    nuevoNodo->valorCaracter = (char*) malloc(sizeof(char) * 50);
    strcpy(nuevoNodo->valorCaracter, caracter);
    nuevoNodo->central = 0;
    nuevoNodo->left = 0;
    nuevoNodo->right = 0;
    return nuevoNodo;
}

struct nodo_as* nuevo_nodo_string(char* string)
{
    struct nodo_as* nuevoNodo = (struct nodo_as*) malloc(sizeof(struct nodo_as));
    nuevoNodo->tipoNodo = HOJA_STRING;
    nuevoNodo->valorString = (char*) malloc(sizeof(char) * 50);
    strcpy(nuevoNodo->valorString, string);
    nuevoNodo->central = 0;
    nuevoNodo->left = 0;
    nuevoNodo->right = 0;
    return nuevoNodo;
}

struct nodo_as* nuevo_nodo_boolean(char* boolean)
{
    struct nodo_as* nuevoNodo = (struct nodo_as*) malloc(sizeof(struct nodo_as));
    nuevoNodo->tipoNodo = HOJA_BOOLEAN;
    nuevoNodo->valorBoolean = (char*) malloc(sizeof(char) * 10);
    strcpy(nuevoNodo->valorBoolean, boolean);
    nuevoNodo->central = 0;
    nuevoNodo->left = 0;
    nuevoNodo->right = 0;
    return nuevoNodo;
}
#endif /* ARBOL_C */

