bison -d sintactico.y
flex lexico.l
gcc -o analizador lex.yy.c sintactico.tab.c
