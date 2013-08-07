class print : public node
{
public:
	node* var;
	string strVal;

	print(node* pVar)
	{
		var = pVar;
		strVal="";
	}

	print(string pStrVal)
	{
		strVal = pStrVal.erase(0,1);
		strVal = strVal.erase(strVal.size()-1, 1);
		myReplace(strVal, "%n", "\n");
	}

	~print()
	{
		delete var;
		freeNodes();
	}

	float run(string scope="global")
	{
		//clog << "[print " << var->run() << "]" << endl;
		if(strVal!="") cout << strVal;
		else if(var->strRun()=="") cout << var->run(scope);
		else cout << var->strRun(scope);

		//cout << s.find("#n") << endl;
		//for(int i=0; i<s.size(); i++) cout << s[i];
		//cout << "COMPARE " << s.compare("hello \n world") << endl;

		//var->run();
		//cout << var->strVal << " " << var->run() << " " << var << endl;
	}
};
