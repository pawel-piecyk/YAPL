enum operationType
{
	SUM,
	SUBTRACT,
	MULTIPLY,
	DIVIDE,
	MODULO
};

class boperation : public node
{
public:
	node* first;
	node* second;
	float val;
	operationType type;

	boperation(node* pFirst, node* pSecond, operationType pType) : first(pFirst), second(pSecond), type(pType)
	{
		//if(type==SUM) clog << "[constructor boperation " << first->run() << " + " << second->run() << endl;
		//else clog << "[constructor boperation " << first->run() << " * " << second->run() << endl;
	}

	~boperation()
	{
		delete first;
		delete second;
		freeNodes();
	}

	float run(string scope="global")
	{
		//clog << "[boperation " << first->run() << " + " << second->run() << endl;
		switch(type)
		{
		case SUM:
			val = first->run(scope) + second->run(scope);
			break;

		case SUBTRACT:
			val = first->run(scope) - second->run(scope);
			break;

		case MULTIPLY:
			val = first->run(scope) * second->run(scope);
			break;

		case DIVIDE:
			val = first->run(scope) / second->run(scope);
			break;

		case MODULO:
			val = (int)first->run(scope) % (int)second->run(scope);
			break;
		}

		return val;
	}
};
