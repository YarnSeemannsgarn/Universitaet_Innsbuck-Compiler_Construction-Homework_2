LEX = flex
CFLAGS = -lfl
CC = gcc

all: solution

lex.yy.c: solution.l
	$(LEX) solution.l

solution: lex.yy.c
	$(CC) -o $@ lex.yy.c $(CFLAGS)

clean: 
	find . -type f -not \( -name "solution.l" -o -name "sample.pas" -o -name "task5.pas" -o -name "Makefile" -o -name "README.md" \) | xargs rm -f

