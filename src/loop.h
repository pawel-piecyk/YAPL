class loop : public node
{
public:
	node* condition;
	operationType type;

	loop(node* pCondition) : condition(pCondition)
	{
		clog << "[loop constructor]" << endl;
	}

	~loop()
	{
		///freeNodes();
		delete condition;
	}

	float run(string scope="global")
	{
		clog << "[loop running " << condition->run(scope) << endl;
		while(condition->run(scope)==1.0)
		{
			for(node* singleNode : subNodes)
			{
				clog << "[loop running node]" << endl;
				singleNode->run(scope);
			}
		}
	}
};
