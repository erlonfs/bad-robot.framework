//+------------------------------------------------------------------+
//|                                   Copyright 2017, Erlon F. Souza |
//|                                       https://github.com/erlonfs |
//+------------------------------------------------------------------+

#property copyright "Copyright 2017, Erlon F. Souza"
#property link      "https://github.com/erlonfs"
#property version   "1.00"

#include <Trade\Trade.mqh>
#include <Trade\PositionInfo.mqh>
#include <Framework\Base.mqh>

class Benchmark : public Base
{
   private:
   
   	//Estrategia
   	MqlRates _rates[];
   	ENUM_TIMEFRAMES _period;
   	double _maxima;
   	double _minima;
   
   	//UI 	   
   	color _corBuy;
   	color _corSell;
   	color _cor;
   	bool _isDesenhar;
   	bool _isEnviarParaTras;
   	bool _isPreencher;
   	
   	void Draw()
   	{
   		if (!_isDesenhar) {
   			return;
   		}	
   		
   		//Drawn something
   			
   	}
   
   	bool GetBuffers() {	
   	
   	   //Get Buffers
   		
   		return true;
   	}
   
   public:
   
   	void SetColor(color cor) {
   		_cor = cor;
   	}
   
   	void SetIsDesenhar(bool isDesenhar) {
   		_isDesenhar = isDesenhar;
   	}
   
   	void SetIsEnviarParaTras(bool isEnviarParaTras) {
   		_isEnviarParaTras = isEnviarParaTras;
   	}
   
   	void SetIsPreencher(bool isPreencher) {
   		_isPreencher = isPreencher;
   	}
   
   	void SetColorBuy(color cor) {
   		_corBuy = cor;
   	};
   
   	void SetColorSell(color cor) {
   		_corSell = cor;
   	};
   
   	void Load() {
   
   	};
   
   	void Execute() {
   	
   	   if(!Base::ExecuteBase()) return;
      		
   		if (GetBuffers()) {  
   			ShowInfo();
   
   		}
   
   	};
};

