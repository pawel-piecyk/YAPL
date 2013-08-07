class ifOperation : public node
{
public:
	node* condition;
	operationType type;
	vector<node*> elseSubNodes;

	ifOperation(node* pCondition) : condition(pCondition)
	{
		clog << "[ifOperation constructor]" << endl;
	}

	~ifOperation()
	{
		for(node* a : elseSubNodes) delete a;
		freeNodes();
		delete condition;
	}

	float run(string scope="global")
	{
		clog << "[ifOperation running " << condition->run(scope) << endl;
		if(condition->run(scope)==1.0)
		{
			for(node* singleNode : subNodes)
			{
				clog << "[iOperation running node]" << endl;
				singleNode->run(scope);
			}
		}else
		{
			clog << "ELSE " << elseSubNodes.size() << endl;
			for(node* singleNode : elseSubNodes)
			{
				clog << "[iOperation running node]" << endl;
				singleNode->run(scope);
			}
		}
	}
};
