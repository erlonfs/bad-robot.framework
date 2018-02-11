//+------------------------------------------------------------------+
//|                                   Copyright 2018, Erlon F. Souza |
//|                                       https://github.com/erlonfs |
//+------------------------------------------------------------------+

#property copyright "Copyright 2018, Erlon F. Souza"
#property link      "https://github.com/erlonfs"

class Logger
{
	private:
	string _logs[5];
	
	void Add(string txt){
		
		string newArray[];		
		ArrayCopy(newArray, _logs);
		
		for(int i = ArraySize(_logs) - 1; i > 0; i--){					
			_logs[i] = newArray[i - 1];			
		}
		
		_logs[0] = txt;
		
	}
	
	public:
		
	void Log(string text) {
	
		StringToUpper(text);
		
		text = (TimeToString(TimeCurrent(), TIME_SECONDS)) + " > " + text;	
		
		if (text != _logs[0]) 
		{
			Add(text);
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
	 
	
};