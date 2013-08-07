NAME=yapl
all:
ifdef NAME
	flex $(NAME)lex.l
	bison -d $(NAME).y --report=state
	g++ -o $(NAME) $(NAME).tab.c -lfl -lm -std=c++0x -Wno-write-strings
else
	@echo "Podaj nazwe (parametr NAME=...)"
endif
	
clean:
ifdef NAME
	rm $(NAME) $(NAME).tab.c $(NAME).tab.h lex.yy.c
else
	@echo "Podaj nazwe (parametr NAME=...)"
endif
