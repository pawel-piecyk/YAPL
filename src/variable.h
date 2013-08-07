class variable : public node
{
public:
	string varName;
	float value;
	bool constant;
	string strVal;
	bool isGlobal;

	variable(string name, bool global=false) : varName(name)//, isGlobal(global)
	{
		constant=false;
	}

	variable(float pValue, bool global=false) : value(pValue)//, isGlobal(global)
	{
		constant=true;
	}

	~variable()
	{
		freeNodes();
	}

	string strRun(string scope="global")
	{
		clog << "STRRUN" << endl;
		if(floats[scope].find(varName)==floats[scope].end() && floats["global"].find(varName)==floats["global"].end())
			{
			clog << "Zwraot stringa " << strings[scope][varName] << endl;
			return strings[scope][varName];
			}
		else return "";
	}

	float run(string scope="global")
	{
		clog << "varrun " << value << endl;
		if(constant) return value;
		else
		{
			if(floats[scope].find(varName)!=floats[scope].end()) return floats[scope][varName];
			else if(floats["global"].find(varName)!=floats["global"].end()) return floats["global"][varName];
			else strVal=strings[scope][varName];
			clog << "svarname " << this->strVal << " " << this << endl;
			/*vector<string>::iterator it;
			it = find(varNames.begin(), varNames.end(), varName);
			if(it!=varNames.end())
			{
				clog << ":(" << endl;
				return integers[varName];
			}
			else procedures[varName]->run();*/
		}

		return -99;
	}
};
