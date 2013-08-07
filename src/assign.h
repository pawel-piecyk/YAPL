class assign : public node
{
public:

	string varName;
	node *variable;
	string strVal;
	bool isGlobal;

	assign(string pVarName, node* pVariable, bool global=false) : varName(pVarName), variable(pVariable), isGlobal(global)
	{

	}

	assign(string pVarName, string pVariable, bool global=false) : varName(pVarName), variable(NULL), isGlobal(global)
	{
		strVal = pVariable.erase(0,1);
		strVal = strVal.erase(strVal.size()-1, 1);

		myReplace(strVal, "%n", "\n");
	}


	float run(string scope="global")
	{
		if(isGlobal) scope="global";
		clog << "[assign " << varName << " <- " << strVal << "]" << endl;
		varNames.push_back(varName);
		if(variable!=NULL && floats["global"].find(varName)!=floats["global"].end()) floats["global"][varName] = variable->run(scope);
		else if(variable!=NULL) floats[scope][varName] = variable->run(scope);
		else
		{
			//variable->run();
			strings[scope][varName] = strVal;
			clog << strVal << endl;
		}
	}
};
