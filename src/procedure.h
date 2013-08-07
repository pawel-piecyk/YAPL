class procedure : public node
{
public:
	int paramCount;
	string paramNames[3];
	node* parameters[3];
	string procName;

	procedure(string pName, string p1, string p2="", string p3=""): paramCount(1)
	{
		//parameters[0] = pName;
		clog << "[procedure constructor " << endl;
		paramNames[0]=p1;
		paramNames[1]=p2;
		paramNames[2]=p3;
	}

	~procedure()
	{
		freeNodes();
		for(node* a : parameters) delete a;
	}

	void setParameters(float p1, float p2=0, float p3=0)
	{
		floats[procName][paramNames[0]] = p1;
		floats[procName][paramNames[1]] = p2;
		floats[procName][paramNames[2]] = p3;
	}

	float run(string scope="global")
	{
		clog << "[procedure run" << endl;
		for(node* singleNode : subNodes)
		{
			singleNode->run(procName);
		}
	}

};

class call : public node
{
public:
	string procName;
	int paramCount;
	node* parameters[3];
	map<string, node*> localVariables;

	call(string pProcName, node* p1, node* p2=NULL, node* p3=NULL)
	{
		clog << "[call constructor" << endl;
		procName = pProcName;
		paramCount = 1;
		if(p2!=NULL) paramCount=2;
		if(p3!=NULL && paramCount==2) paramCount=3;
		parameters[0] = p1;
		if(paramCount==2 || paramCount==3) parameters[1] = p2;
		if(paramCount==3) parameters[2] = p3;
		//procedures[procName]->parameters[0] = param1;
	}

	~call()
	{
		freeNodes();
		for(node* a : parameters) delete a;
	}


	float run(string scope="global")
	{
		clog << "[call " << procName << "]" << endl;
		if(paramCount==1) procedures[procName]->setParameters(parameters[0]->run(procName), NULL, NULL);
		if(paramCount==2) procedures[procName]->setParameters(parameters[0]->run(procName), parameters[1]->run(procName), NULL);
		if(paramCount==3) procedures[procName]->setParameters(parameters[0]->run(procName), parameters[1]->run(procName), parameters[2]->run(procName));
		procedures[procName]->run(procName);
	}
};


