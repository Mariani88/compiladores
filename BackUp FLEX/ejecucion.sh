#!/bin/sh

flex ejercicio.l
gcc -o ejecutable lex.yy.c
./ejecutable
