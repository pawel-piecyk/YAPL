//map<string, map<string, float> > floats2;

vector<string> 		varNames; //nazwy zmiennych
map<string, map<string, int> > 	integers;
map<string, map<string, float> > 	floats;
map<string, map<string, string> > strings;

class node;
class procedure;

map<string, procedure*>	procedures;

class node
{
public:
	vector<node*> subNodes;
	string strVal;

	virtual float run(string scope="global")
	{
		for(node* singleNode : subNodes)
		{
			singleNode->run(scope);
		}
	}

	virtual string strRun(string scope="global") {return "";}

	void freeNodes()
	{
		for(node *a : subNodes) delete a;
	}

	virtual ~node() { freeNodes(); }
};


void myReplace(std::string& str, const std::string& oldStr, const std::string& newStr)
		{
		  size_t pos = 0;
		  while((pos = str.find(oldStr, pos)) != std::string::npos)
		  {
		     str.replace(pos, oldStr.length(), newStr);
		     pos += newStr.length();
		  }
		}


#include "assign.h"
#include "boperation.h"
#include "condition.h"
#include "loop.h"
#include "ifoperation.h"
#include "variable.h"
#include "procedure.h"
#include "print.h"











