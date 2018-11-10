#% cat makefile
interprete: lex.yy.c interprete.tab.c interprete.tab.h
	gcc -o interprete interprete.tab.c lex.yy.c

interprete.tab.c interprete.tab.h: interprete.y
	win_bison -d interprete.y

lex.yy.c: interprete.l interprete.tab.h
	win_flex interprete.l
#% make interprete
#win_bison -d interprete.y
#win_flex interprete.l
#gcc interprete.tab.c lex.yy.c -o interprete
#%