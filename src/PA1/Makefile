
ASSN = 1
CLASS= cs143
CLASSDIR= ../..
SRC= stack.cl README 
LSRC= Makefile atoi.cl stack.test

CC=gcc
CFLAGS=-g

.c.o:
	${CC} ${CFLAGS} -c $<

compile: stack.s

stack.s: stack.cl atoi.cl list.cl
	${CLASSDIR}/bin/coolc stack.cl atoi.cl list.cl

test:	compile
	@echo stack.test
	${CLASSDIR}/bin/spim -file stack.s < stack.test

run: compile
	${CLASSDIR}/bin/spim -file stack.s

clean :
	rm -f *.s core *~
