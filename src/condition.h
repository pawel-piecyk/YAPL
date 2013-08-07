enum condType
{
	EQUAL,
	NEQUAL,
	GREATER,
	LOWER,
	GREATER_EQ,
	LOWER_EQ
};

class condition : public node
{
public:
	node* first;
	node* second;
	condType type;

	condition(node* pFirst, node* pSecond, condType pType) : first(pFirst), second(pSecond), type(pType)
	{
		clog << "[conditional contstructor]" << endl;
	}

	~condition()
	{
		delete first;
		delete second;
		freeNodes();
	}

	float run(string scope="global")
	{
		switch(type)
		{
		case EQUAL:
			return (first->run(scope) == second->run(scope));
			break;

		case NEQUAL:
			return (first->run(scope) != second->run(scope));
			break;

		case GREATER:
			return (first->run(scope) > second->run(scope));
			break;

		case LOWER:
			return (first->run(scope) < second->run(scope));
			break;

		case GREATER_EQ:
			return (first->run(scope) >= second->run(scope));
			break;

		case LOWER_EQ:
			return (first->run(scope) <= second->run(scope));
			break;

		}

		//return val;
	}
};
