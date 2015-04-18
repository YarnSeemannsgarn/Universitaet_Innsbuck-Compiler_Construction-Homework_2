LEX = flex
CFLAGS = -lfl
CC = gcc

all: solution

lex.yy.c: solution.l
	$(LEX) solution.l

solution: lex.yy.c
	$(CC) -o $@ lex.yy.c $(CFLAGS)

clean: 
	find . -type f -not \( -name "solution.l" -o -name "sampleWithModula2Comments.pas" -o -name "Makefile" -o -name "README.md" -o -name "task2.txt" \) | xargs rm -f

