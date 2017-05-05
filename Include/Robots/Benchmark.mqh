//+------------------------------------------------------------------+
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <Trade\Trade.mqh>
#include <Trade\PositionInfo.mqh>
#include <Framework\Base.mqh>

class Benchmark : public Base
{
private:
	//Price   		
	MqlRates _rates[];
	ENUM_TIMEFRAMES _period;

	//Estrategia
	double _maxima;
	double _minima;

	//Grafico 	   
	color _corBuy;
	color _corSell;
	color _cor;
	bool _isDesenhar;
	bool _isEnviarParaTras;
	bool _isPreencher;

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

	void Watch() {

		AtualizarLastPrice();

		if (HasPositionOpen()) {
			ManagePosition();
			return;
		}

		if (!Validate()) {
			return;
		}

		if (GetBuffers()) {

			ShowInfo();

		}

	};

	void Desenhar()
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

};

