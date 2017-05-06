//+------------------------------------------------------------------+
//|                                   Copyright 2016, Erlon F. Souza |
//|                                       https://github.com/erlonfs |
//+------------------------------------------------------------------+

#property copyright "Copyright 2016, Erlon F. Souza"
#property link      "https://github.com/erlonfs"
#property version   "1.00"

#include <Trade\Trade.mqh>
#include <Trade\PositionInfo.mqh>
#include <Framework\Base.mqh>

class FirstCandle : public Base
{
private:
	//Price   		
	MqlRates _rates[];
	ENUM_TIMEFRAMES _period;

	//Estrategia
	double _maxima;
	double _minima;

	bool _waitBuy;
	bool _waitSell;
	int _qtdCopiedRates;

	//Grafico 	   
	color _corBuy;
	color _corSell;
	color _cor;
	bool _isDesenhar;
	bool _isEnviarParaTras;
	bool _isPreencher;
	
	void VerifyStrategy(int order) {

		if (order == ORDER_TYPE_BUY) {

			double _entrada = _maxima + GetSpread();
			double _auxStopGain = NormalizeDouble((_entrada + GetStopGain()), _Digits);
			double _auxStopLoss = NormalizeDouble((_entrada - GetStopLoss()), _Digits);

			if (GetLastPrice().last >= _entrada) {

				if (!HasPositionOpen()) {
					_waitBuy = false;
					Buy(_entrada, _auxStopLoss, _auxStopGain, getNameRobot());
				}

			}

			return;


		}

		if (order == ORDER_TYPE_SELL) {

			double _entrada = _minima - GetSpread();
			double _auxStopGain = NormalizeDouble((_entrada - GetStopGain()), _Digits);
			double _auxStopLoss = NormalizeDouble((_entrada + GetStopLoss()), _Digits);

			if (GetLastPrice().last <= _entrada) {

				if (!HasPositionOpen()) {
					_waitSell = false;
					Sell(_entrada, _auxStopLoss, _auxStopGain, getNameRobot());
				}

			}

			return;

		}

	}

	bool FindCondition() {

		bool isMatch = false;

		if (ArraySize(_rates) > 1) {
			isMatch = true;
			_maxima = _rates[ArraySize(_rates) - 1].high;
			_minima = _rates[ArraySize(_rates) - 1].low;
		}

		if (isMatch) {

			for (int i = ArraySize(_rates) - 1; i >= 0; i--) {

				if (_rates[i].high > _maxima + GetSpread() || _rates[i].low < _minima - GetSpread()) {
					isMatch = false;
				}

				if (GetLastPrice().last > _maxima + GetSpread() || GetLastPrice().last < _minima - GetSpread()) {
					isMatch = false;
				}

			}

		}

		return isMatch;

	}

	void Draw(double price, color cor)
	{

		if (!_isDesenhar) {
			return;
		}

		string objName = "LINE" + (string)price;
		ObjectCreate(0, objName, OBJ_HLINE, 0, 0, price);

		ObjectSetInteger(0, objName, OBJPROP_COLOR, cor);
		ObjectSetInteger(0, objName, OBJPROP_BORDER_COLOR, clrBlack);
		ObjectSetInteger(0, objName, OBJPROP_STYLE, STYLE_SOLID);
		ObjectSetInteger(0, objName, OBJPROP_WIDTH, 1);
		ObjectSetInteger(0, objName, OBJPROP_BACK, _isEnviarParaTras);
		ObjectSetInteger(0, objName, OBJPROP_FILL, _isPreencher);

		//ARROW PRICE
		objName = "SETA" + (string)price;
		ObjectCreate(0, objName, OBJ_ARROW_RIGHT_PRICE, 0, _rates[0].time, price);
		ObjectSetInteger(0, objName, OBJPROP_COLOR, cor);
		ObjectSetInteger(0, objName, OBJPROP_BORDER_COLOR, clrBlack);
		ObjectSetInteger(0, objName, OBJPROP_STYLE, STYLE_SOLID);
		ObjectSetInteger(0, objName, OBJPROP_WIDTH, 2);
		ObjectSetInteger(0, objName, OBJPROP_BACK, false);
		ObjectSetString(0, objName, OBJPROP_TEXT, "ENTRADA EM " + (string)price);
	}

	void ClearDraw(double price) {

		if (!_isDesenhar) {
			return;
		}

		ObjectDelete(0, "LINE" + (string)price);
		ObjectDelete(0, "SETA" + (string)price);
	}

	bool GetBuffers() {

		if (!IsNewCandle()) {
			return ArraySize(_rates) > 0;
		}

		ZeroMemory(_rates);
		ArraySetAsSeries(_rates, true);
		ArrayFree(_rates);

		MqlDateTime startDate;
		MqlDateTime stopDate;

		TimeCurrent(startDate);
		stopDate = startDate;

		startDate.hour = GetHoraInicio().hour;
		startDate.min = GetHoraInicio().min;
		startDate.sec = 0;

		int copiedRates = CopyRates(GetSymbol(), GetPeriod(), StructToTime(stopDate), StructToTime(startDate), _rates);

		return copiedRates > 0;

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

		RefreshLastPrice();

		if (HasPositionOpen()) {
			ManagePosition();
			return;
		}

		if (!Validate()) {
			return;
		}

		if (GetBuffers()) {

			ClearDraw(_maxima);
			ClearDraw(_minima);

			if (FindCondition()) {
				Draw(_minima, _corSell);
				Draw(_maxima, _corBuy);

				VerifyStrategy(ORDER_TYPE_BUY);
				VerifyStrategy(ORDER_TYPE_SELL);
			}

			SetInfo("COMPRA " + (string)_maxima + " VENDA " + (string)_minima);
			ShowInfo();

		}

	};

};

