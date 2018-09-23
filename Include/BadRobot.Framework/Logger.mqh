//+------------------------------------------------------------------+
//|                                   Copyright 2018, Erlon F. Souza |
//|                                       https://github.com/erlonfs |
//+------------------------------------------------------------------+

#property copyright "Copyright 2018, Erlon F. Souza"
#property link      "https://github.com/erlonfs"
#property version    "1.0"

#define MAX_SIZE_TEXT (50)

class Logger
{
	private:
	string _logs[10];
	bool _hasChanges;
	
	void Add(string txt){
		
		string newArray[];		
		ArrayCopy(newArray, _logs);
		
		for(int i = ArraySize(_logs) - 1; i > 0; i--){					
			_logs[i] = newArray[i - 1];			
		}
		
		_logs[0] = txt;
		_hasChanges = true;
		
		printf(txt);//TODO remove later
		
	}
	
	public:
	
	Logger(){
		
	}
	
	Logger(const Logger& other){
		this = other;
	}
	
	void Log(string text) 
	{
		
		if(text == NULL) return;
		
		StringToUpper(text);
		StringTrimLeft(text);
		StringTrimRight(text);
		
		int length = StringLen(text);
		if(length > MAX_SIZE_TEXT + 3)
		{
			text = StringSubstr(text, 0, MAX_SIZE_TEXT - 3) + "...";
		}
		
		string newText = (TimeToString(TimeCurrent(), TIME_SECONDS)) + " > " + text;
		
		if(Logger::Last() == NULL){
			Add(newText);
			return;
		}
		
		string textAux[];
		
		StringSplit(Logger::Last(), 62, textAux);
		StringTrimLeft(textAux[1]);
		StringTrimRight(textAux[1]);
		
		if (text != textAux[1]) 
		{
			Add(newText);
		}

	}
	
	string Get(){
		
		string logs = "";
		
		for(int i = 0; i < ArraySize(_logs); i++){		
			logs += _logs[i] + "\n"; 		
		}
		
		return logs;
		
	}
	
	string Get(int index){
		return _logs[index];
	}		
	
	string First(){
		return _logs[ArraySize(_logs) - 1];
	}	
	
	string Last(){
		return _logs[0];
	}	
	
	bool HasChanges()
	{
		if(_hasChanges)
		{
			_hasChanges = false;
			return true;
		}
		
		return false;
		
	}
	 
	
};