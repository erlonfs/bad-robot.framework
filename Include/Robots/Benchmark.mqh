//+------------------------------------------------------------------+
//|                                   Copyright 2017, Erlon F. Souza |
//|                                       https://github.com/erlonfs |
//+------------------------------------------------------------------+

#property copyright "Copyright 2017, Erlon F. Souza"
#property link      "https://github.com/erlonfs"

#include <Trade\Trade.mqh>
#include <Trade\PositionInfo.mqh>
#include <Framework\Base.mqh>

class Benchmark : public Base
{
   private:
   
   	MqlRates _rates[];
   	ENUM_TIMEFRAMES _period;     
   
   public:
      
   	void Load() 
   	{
         //TODO
   	};
   
   	void Execute() {
   	
   	   if(!Base::ExecuteBase()) return;
      		
   		//TODO   
   	};
};

