%{
/* LOGO */

int a;

%}

%{
#include <stdio.h>
#include <iostream>
#include <map>
#include <vector>
#include <boost/lexical_cast.hpp>
#include <fstream>
#include <algorithm>

int yylex();
int yyerror(char *);

using namespace std;

#include "ast.h"

node rootNode;

node* currentNode = &rootNode;
node* newNode;
vector<node*> prevNode;
node* elseNode;

%}

%union
{
	float fVal;
	int intVal;
	char strVal[256];
	node *nodeVal;
};
/**
 * Tokeny
 */
%token IF STRING BEGIN_BLOCK END_BLOCK PDEF ELSE ENDIF RIGHT LEFT MOVE LOOP ENDWHILE PRINT SET ASSIGN EXEC GLOBAL COMMENT
%token VAR NUM FLOAT
%token NEQ EQ GT LE GEQ LEQ
/**
 * Wiazania (Kolejnosc linii odpowiada wzrostowi priorytetu)
 */
%nonassoc ASSIGN NEQ EQ GT LE GEQ LEQ
%left '-' '+'
%left '*' '/'
/**
 * Reguly gramatyki
 */
%%
input:
    | input command
    ;

command : if
	| loop
	| def
	| exec
	| PRINT exp ';' { currentNode->subNodes.push_back(new print($<nodeVal>2)); }
	| PRINT VAR ';' {
		currentNode->subNodes.push_back(new print(new variable($<strVal>2)));
	}
	| PRINT STRING ';' { currentNode->subNodes.push_back(new print($<strVal>2)); clog << "[print string " << $<strVal>2 << " " << currentNode << "]" << endl; /*cout << $<intVal>2 << "num" << endl;*/ }
    | SET VAR ASSIGN exp ';' {
    	currentNode->subNodes.push_back(new assign($<strVal>2, $<nodeVal>4));
    	}
    | SET GLOBAL VAR ASSIGN exp ';' {
    	currentNode->subNodes.push_back(new assign($<strVal>2, $<nodeVal>4, true));
    	}
    | SET VAR ASSIGN STRING ';' {
        	currentNode->subNodes.push_back(new assign($<strVal>2, $<strVal>4));
    }
    | SET GLOBAL VAR ASSIGN STRING ';' {
            	currentNode->subNodes.push_back(new assign($<strVal>2, $<strVal>4, true));
        }
    ;

if  :
		IF cond ':' {
			clog << "IF " << currentNode << endl;
			prevNode.push_back(currentNode);
			newNode = new ifOperation($<nodeVal>2);
			currentNode->subNodes.push_back(newNode);
			currentNode = newNode;
		}
		BEGIN_BLOCK
		input
		END_BLOCK {
			currentNode = prevNode.back(); prevNode.pop_back();
		}
        |
        IF cond '~' {
        	prevNode.push_back(currentNode);
        	newNode = new ifOperation($<nodeVal>2);
        	currentNode->subNodes.push_back(newNode);
        	currentNode = newNode;
        }
        BEGIN_BLOCK
        input
        END_BLOCK
        ELSE	  {
        	elseNode = currentNode;
        	currentNode = new ifOperation(new node());
        }
        BEGIN_BLOCK
        input
        END_BLOCK {
        	static_cast<ifOperation*>(elseNode)->elseSubNodes = currentNode->subNodes;
        	currentNode = prevNode.back(); prevNode.pop_back();
        }
        ;

loop  : LOOP cond ':' {
 			newNode = new loop($<nodeVal>2);
 			prevNode.push_back(currentNode);
 			currentNode->subNodes.push_back(newNode);
 			currentNode = newNode;
 			clog << "loop! " << $<nodeVal>2 << " " << currentNode << endl;
 		}
 	  BEGIN_BLOCK
       input
       END_BLOCK{
 		  	currentNode = prevNode.back(); prevNode.pop_back();
		};

def  : PDEF name ':' name {
			prevNode.push_back(currentNode);
 			currentNode = static_cast<node*>(new procedure($<strVal>2, $<strVal>4));
 			clog << "JEST DEF! " << $<strVal>2 << " " << $<strVal>4 << " " << currentNode << endl;
 			procedures[$<strVal>2] = static_cast<procedure*>(currentNode);
 		}
 	  BEGIN_BLOCK
       input
       END_BLOCK
       {
 		 currentNode = prevNode.back(); prevNode.pop_back();
        		}
       |
       PDEF name ':' name',' name {
    	   prevNode.push_back(currentNode);
       	currentNode = static_cast<node*>(new procedure($<strVal>2, $<strVal>4, $<strVal>6));
       	clog << "JEST DEF! " << $<strVal>2 << " " << $<strVal>4 << " " << $<strVal>6 << " " << currentNode << endl;
       	procedures[$<strVal>2] = static_cast<procedure*>(currentNode);
       }
       BEGIN_BLOCK
       input
       END_BLOCK {
    	    //clog << "powrot po def procedury" << endl;
    	   currentNode = prevNode.back(); prevNode.pop_back();
      };

name:	VAR	{ clog << "JEST DEF NAME " << $<strVal>1 << endl; };

exec : EXEC name ASSIGN NUM ';' {
		clog << "JEST EXEC! " << $<strVal>2 << " " << $<intVal>4 << " " << currentNode << endl;
		currentNode->subNodes.push_back(new call($<strVal>2, new variable($<intVal>4)));
	}
	|
	EXEC name ASSIGN FLOAT ';' {
			clog << "JEST EXEC! " << $<strVal>2 << " " << $<fVal>4 << " " << currentNode << endl;
			currentNode->subNodes.push_back(new call($<strVal>2, new variable($<fVal>4)));
		}
	|
	EXEC name ASSIGN VAR ';' {
		clog << "JEST EXEC! " << $<strVal>2 << " " << $<intVal>4 << " " << currentNode << endl;
		currentNode->subNodes.push_back(new call($<strVal>2, new variable($<strVal>4)));
	}
	|
	EXEC name ASSIGN NUM',' NUM ';' {
			clog << "JEST EXEC! " << $<strVal>2 << " " << $<intVal>4 << " " << $<intVal>6 << " " << currentNode << endl;
			currentNode->subNodes.push_back(new call($<strVal>2, new variable($<intVal>4), new variable($<intVal>6)));
		}
	|
	EXEC name ASSIGN FLOAT',' FLOAT ';' {
				clog << "JEST EXEC! " << $<strVal>2 << " " << $<intVal>4 << " " << $<intVal>6 << " " << currentNode << endl;
				currentNode->subNodes.push_back(new call($<strVal>2, new variable($<fVal>4), new variable($<fVal>6)));
			}
		|
	EXEC name ASSIGN VAR','VAR ';' {
			clog << "JEST EXEC! " << $<strVal>2 << " " << $<intVal>4 << " " << currentNode << endl;
			currentNode->subNodes.push_back(new call($<strVal>2, new variable($<strVal>4), new variable($<strVal>6)));
		};

cond: exp NEQ exp	{ $<nodeVal>$ = new condition($<nodeVal>1, $<nodeVal>3, NEQUAL); }
    | exp EQ exp	{ $<nodeVal>$ = new condition($<nodeVal>1, $<nodeVal>3, EQUAL); }
    | exp GT exp	{ $<nodeVal>$ = new condition($<nodeVal>1, $<nodeVal>3, GREATER); }
    | exp LE exp	{ $<nodeVal>$ = new condition($<nodeVal>1, $<nodeVal>3, LOWER); }
    | exp GEQ exp	{ $<nodeVal>$ = new condition($<nodeVal>1, $<nodeVal>3, GREATER_EQ); }
    | exp LEQ exp	{ $<nodeVal>$ = new condition($<nodeVal>1, $<nodeVal>3, LOWER_EQ); }
    ;

exp : NUM			{ $<nodeVal>$ = new variable((int)$<intVal>1); clog << $<intVal>1 << " " << $<nodeVal>$ << endl; }
	| FLOAT			{ $<nodeVal>$ = new variable($<fVal>1); clog << $<intVal>1 << " " << $<nodeVal>$ << endl; }
    | VAR			{ $<nodeVal>$ = new variable($<strVal>1);  }
    | exp '+' exp 	{
    	$<nodeVal>$ = new boperation($<nodeVal>1, $<nodeVal>3, SUM);
    }
    | exp '-' exp 	{
    	$<nodeVal>$ = new boperation($<nodeVal>1, $<nodeVal>3, SUBTRACT);
    }
    | '-' exp		{
    	$<nodeVal>$ = new boperation($<nodeVal>2, new variable(-1), MULTIPLY);
    }
    | exp '*' exp 	{
        $<nodeVal>$ = new boperation($<nodeVal>1, $<nodeVal>3, MULTIPLY);
    }
    | exp '/' exp 	{
        $<nodeVal>$ = new boperation($<nodeVal>1, $<nodeVal>3, DIVIDE);
    }
    | exp '%' exp 	{
        $<nodeVal>$ = new boperation($<nodeVal>1, $<nodeVal>3, MODULO);
    }
    | '(' exp ')' {
    	$<nodeVal>$ = $<nodeVal>2;
    };


%%
/**
 * Dolaczenie skanera
 */
#include "lex.yy.c"

/**
 * Wywolanie parsera
 */
int main()
{
	cout << "YAPL Interpreter 0.1 beta" << endl;
	ofstream ofs("logfile");
	streambuf* backup = clog.rdbuf();
	clog.rdbuf(ofs.rdbuf());

	yyparse();

	clog << "Root SubNodes " << rootNode.subNodes.size() << " " << &rootNode << endl;

	rootNode.run();
	clog.rdbuf(backup);
	ofs.close();
	cout << "\n";
}

/**
 * Obsluga bledow
 */
int yyerror(char *s) {
   printf("Error: %s (line %d) \n", s, yylineno);
}
