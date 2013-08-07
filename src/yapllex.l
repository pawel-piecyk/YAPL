%{

#include <math.h>

%}

NUM [0-9]+
FLOAT [0-9]+"."[0-9]+

%%
"#".*"\n" 
"<-"	{return ASSIGN;}
"if"	{return IF;}
"else"	{return ELSE;}
"@b"	{return BEGIN_BLOCK;}
"@e"	{return END_BLOCK;}
"fi"	{return ENDIF;}
"<>"	{return NEQ;}
"=="	{return EQ;}
">"		{return GT;}
"<"		{return LE;}
">="	{return GEQ;}
"<="	{return LEQ;}
"dspl" 	{return PRINT;}
"set"	{return SET;}
"loop"	{return LOOP;}
"def"	{return PDEF;}
"exec"	{return EXEC;}
"::"	{return GLOBAL;}

"\n"	{yylineno++;}
[ \t]+ /* Zjadamy biale znaki */



[a-zA-Z]+[0-9]* {strcpy(yylval.strVal, yytext); return VAR;}
"\"".*"\"" {strcpy(yylval.strVal, yytext); return STRING;}
{NUM}	{yylval.intVal = atoi(yytext); return NUM;}
{FLOAT}	{yylval.fVal = atof(yytext); return FLOAT;}

.	{ 
		/**
		 * Reszte znaczkow pobieramy pojednynczo
		 * (w ten sposob pobieramy + - * / =)
		 */
		return(yytext[0]);
	}

%%