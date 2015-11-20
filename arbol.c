#ifndef ARBOL_C
#define ARBOL_C

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include "tabla.c"

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
#define HOJACARACTER 24
#define HOJABOOLEAN 25
#define SUMA 26
#define RESTA 27
#define MULTIPLICACION 28
#define DIVISION 29

typedef struct ast_node {
	char* operador;
	char* variable;
	int tipoNodo;
	int valorEntero;
	char* valorCaracter;
	float valorFlotante;
	char* valorString;
	char* valorBoolean;
	struct ast_node* central;
	struct ast_node* left;
	struct ast_node* right;
} ast_node;

void imprimirTipoDeNodo(ast_node* arbol) {
	switch (arbol->tipoNodo) {
	case 1:
		printf("Nodo entero\n");
		break;
	case 2:
		printf("Nodo factor float\n");
		break;
	case 3:
		printf("Nodo termino float\n");
		break;
	case 4:
		printf("Nodo expresion float\n");
		break;
	case 5:
		printf("Nodo declaracion\n");
		break;
	case 6:
		printf("Nodo asignacion\n");
		break;
	case 7:
		printf("Nodo suma mixta\n");
		break;
	case 8:
		printf("Nodo resta mixta\n");
		break;
	case 9:
		printf("Nodo multiplicacion mixta\n");
		break;
	case 10:
		printf("Nodo factor entero\n");
		break;
	case 11:
		printf("Nodo termino entero\n");
		break;
	case 12:
		printf("Nodo expresion entera\n");
		break;
	case 13:
		printf("Nodo expresion\n");
		break;
	case 14:
		printf("Nodo condicion\n");
		break;
	case 15:
		printf("Nodo if\n");
		break;
	case 16:
		printf("Nodo while\n");
		break;
	case 17:
		printf("Nodo sentencia\n");
		break;
	case 18:
		printf("Nodo cuerpo\n");
		break;
	case 19:
		printf("Nodo main\n");
		break;
	case 20:
		printf("Nodo variable\n");
		break;
	case 21:
		printf("Nodo flotante\n");
		break;
	case 22:
		printf("Nodo string\n");
		break;
	case 23:
		printf("Nodo division mixta\n");
		break;
	case 24:
		printf("Nodo caracter\n");
		break;
	case 25:
		printf("Nodo boolean\n");
		break;

	default:
		printf("DESCONOCIDO\n");
		break;
	}
}

void imprimirArbol(ast_node* arbol) {
	int esNodoHoja = 0;
	struct ast_node* nodoActual = arbol;
	while (nodoActual->left) {
		printf("Tipo de nodo:%d \n", nodoActual->tipoNodo);
		nodoActual = nodoActual->left;
		if (!nodoActual->left) {
			printf("Tipo de nodo:%d \n", nodoActual->tipoNodo);
		}
	}
}
void mostrarArbol(struct ast_node* arbol) {
	if (arbol == NULL )
		return;

	//printf("%d\n", arbol->tipoNodo);
	imprimirTipoDeNodo(arbol);
	mostrarArbol(arbol->left);
//printf("Fin del nodo izquierdo\n ");
	mostrarArbol(arbol->right);
//printf("Fin del nodo derecho\n ");
}

void comprobarArbol(struct ast_node* arbol) {
	/*
	struct ast_node* nodoActual = arbol;
	printf("%d\n", nodoActual->tipoNodo);
	nodoActual = nodoActual->right;
	printf("%d\n", nodoActual->tipoNodo);
	nodoActual = nodoActual->right;
	printf("%d\n", nodoActual->tipoNodo);
	nodoActual = nodoActual->right;
	printf("%d\n", nodoActual->tipoNodo);
	*/

struct ast_node* nodoActual = arbol;
imprimirTipoDeNodo( nodoActual);
nodoActual = nodoActual->right;
imprimirTipoDeNodo( nodoActual);
nodoActual = nodoActual->right;
imprimirTipoDeNodo( nodoActual);
nodoActual = nodoActual->right;
imprimirTipoDeNodo( nodoActual);

nodoActual = nodoActual->right;
imprimirTipoDeNodo( nodoActual);
}

struct ast_node* nuevo_nodo_expresion(int tipoNodo, char* operador,
	struct ast_node* left, struct ast_node* right) {
struct ast_node* nuevoNodo = (struct ast_node*) malloc(sizeof(struct ast_node));
nuevoNodo->operador = (char*) malloc(sizeof(char) * 2);
strcpy(nuevoNodo->operador, operador);
nuevoNodo->tipoNodo = tipoNodo;
nuevoNodo->central = 0;
nuevoNodo->right = right;
nuevoNodo->left = left;
return nuevoNodo;
}

struct ast_node* nuevo_nodo_if(struct ast_node* condicion,
	struct ast_node* central, struct ast_node* right) {
struct ast_node* nuevoNodo = (struct ast_node*) malloc(sizeof(struct ast_node));
nuevoNodo->operador = 0;
nuevoNodo->tipoNodo = SENTENCIAIF;
nuevoNodo->central = central;
nuevoNodo->right = right;
nuevoNodo->left = condicion;
return nuevoNodo;
}

struct ast_node* nuevo_nodo_entero(int valor) {
struct ast_node* nuevoNodo = (struct ast_node*) malloc(sizeof(struct ast_node));
nuevoNodo->tipoNodo = HOJAENTERO;
nuevoNodo->valorEntero = valor;
nuevoNodo->right = 0;
nuevoNodo->left = 0;
nuevoNodo->central = 0;
return nuevoNodo;
}

struct ast_node* nuevo_nodo_variable(char* variable) {
struct ast_node* nuevoNodo = (struct ast_node*) malloc(sizeof(struct ast_node));
nuevoNodo->tipoNodo = HOJAVARIABLE;
nuevoNodo->variable = (char*) malloc(sizeof(char) * 50);
strcpy(nuevoNodo->variable, variable);
nuevoNodo->central = 0;
nuevoNodo->right = 0;
nuevoNodo->left = 0;
return nuevoNodo;
}

struct ast_node* nuevo_nodo_flotante(float valor) {
struct ast_node* nuevoNodo = (struct ast_node*) malloc(sizeof(struct ast_node));
nuevoNodo->tipoNodo = HOJAFLOTANTE;
nuevoNodo->valorFlotante = valor;
nuevoNodo->right = 0;
nuevoNodo->left = 0;
return nuevoNodo;
}

struct ast_node* nuevo_nodo_caracter(char* caracter) {
struct ast_node* nuevoNodo = (struct ast_node*) malloc(sizeof(struct ast_node));
nuevoNodo->tipoNodo = HOJACARACTER;
nuevoNodo->valorCaracter = caracter;
nuevoNodo->central = 0;
nuevoNodo->left = 0;
nuevoNodo->right = 0;
return nuevoNodo;
}

struct ast_node* nuevo_nodo_string(char* string) {
struct ast_node* nuevoNodo = (struct ast_node*) malloc(sizeof(struct ast_node));
nuevoNodo->tipoNodo = HOJASTRING;
nuevoNodo->valorBoolean = (char*) malloc(sizeof(char) * 50);
strcpy(nuevoNodo->valorString, string);
nuevoNodo->central = 0;
nuevoNodo->left = 0;
nuevoNodo->right = 0;
return nuevoNodo;
}

struct ast_node* nuevo_nodo_boolean(char* boolean) {
struct ast_node* nuevoNodo = (struct ast_node*) malloc(sizeof(struct ast_node));
nuevoNodo->tipoNodo = HOJABOOLEAN;
nuevoNodo->valorBoolean = (char*) malloc(sizeof(char) * 10);
strcpy(nuevoNodo->valorBoolean, boolean);
nuevoNodo->central = 0;
nuevoNodo->left = 0;
nuevoNodo->right = 0;
return nuevoNodo;
}
#endif /* ARBOL_C */

