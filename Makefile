a4: a4.l a4.y
	bison -d a4.y
	flex a4.l
	g++ a4.tab.c lex.yy.c -lfl