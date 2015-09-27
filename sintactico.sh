mkdir archivosDelCompilador
bison -d sintactico.y
flex lexico.l


mv  lex.yy.c /home/matias/Escritorio/practica/archivosDelCompilador/
mv  sintactico.tab.c /home/matias/Escritorio/practica/archivosDelCompilador/
mv  sintactico.tab.h /home/matias/Escritorio/practica/archivosDelCompilador/

cd archivosDelCompilador
gcc -o analizador lex.yy.c sintactico.tab.c

./analizador
