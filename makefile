parser: main.o syntax.tab.o 
	cc -o parser main.o syntax.tab.o -lfl -ly

main.o: main.c  
	cc -c main.c

syntax.tab.o: syntax.tab.c 
	cc -c syntax.tab.c

syntax.tab.c: syntax.y  
	bison -d -v syntax.y
