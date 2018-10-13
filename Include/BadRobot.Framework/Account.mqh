//+------------------------------------------------------------------+
//|                                   Copyright 2018, Erlon F. Souza |
//|                                       https://github.com/erlonfs |
//+------------------------------------------------------------------+

#property copyright "Copyright 2018, Erlon F. Souza"
#property link      "https://github.com/erlonfs"

class Account
{
	private:
		ENUM_ACCOUNT_TRADE_MODE _tradeMode;
		ENUM_ACCOUNT_MARGIN_MODE _marginMode;
		
	public:
	
		Account(){
			_tradeMode = (ENUM_ACCOUNT_TRADE_MODE)AccountInfoInteger(ACCOUNT_TRADE_MODE);		
			_marginMode = (ENUM_ACCOUNT_MARGIN_MODE)AccountInfoInteger(ACCOUNT_MARGIN_MODE);		
		}
		
		~Account(){
		
		}
		
	
		bool IsReal(){			
			return _tradeMode == ACCOUNT_TRADE_MODE_REAL;
		}
		
		bool IsDemo(){
			return _tradeMode == ACCOUNT_TRADE_MODE_DEMO;
		}
		
		bool IsHedging(){
			return _marginMode == ACCOUNT_MARGIN_MODE_RETAIL_HEDGING;
		}
	
	 
	
};