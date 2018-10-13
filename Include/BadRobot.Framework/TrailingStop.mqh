//+------------------------------------------------------------------+
//|                                   Copyright 2018, Erlon F. Souza |
//|                                       https://github.com/erlonfs |
//+------------------------------------------------------------------+

#property copyright "Copyright 2018, Erlon F. Souza"
#property link      "https://github.com/erlonfs"
#property version    "1.0"

#include <Trade\Trade.mqh>
#include <BadRobot.Framework\Position.mqh>
#include <BadRobot.Framework\Logger.mqh>

class TrailingStop
{
	private:		
			
		CTrade _trade;
		Position _position;
		Logger _logger;
	
		bool _actived;		
		int _start;
		int _value;
		
		bool ManageTrailingStop()
		{
			if (!IsActived()){ return false; }
	
			if (GetPositionType() == POSITION_TYPE_BUY)
			{
				if (_position.GetLastPrice() - _position.GetPositionLoss() >= _position.GetStopLoss() + _position.ToPoints(_start))
				{
					_trade.PositionModify(_position.GetSymbol(), _position.GetPositionLoss() + _position.ToPoints(_value), _position.GetPositionGain());
					_logger.Log("Stop ajustado trailing stop. " + (string)_position.GetPositionLoss());
					return true;
				}
	
			}
	
			if (GetPositionType() == POSITION_TYPE_SELL)
			{	
				if (_position.GetPositionLoss() - _position.GetLastPrice() >= _position.GetStopLoss() + _position.ToPoints(_start))
				{
					_trade.PositionModify(_position.GetSymbol(), _position.GetPositionLoss() - _position.ToPoints(_value), _position.GetPositionGain());
					_logger.Log("Stop ajustado trailing stop. " + (string)_position.GetPositionLoss());
					return true;
				}
	
			}
	
			return false;
	
		}		
	
		
	public:
	
		TrailingStop()
		{			
			
		}	
		
		~TrailingStop()
		{
					
		}
		
		void SetupDependencies(CTrade &trade, Position &position, Logger &logger)
		{
			_trade = trade;
			_logger = logger;
			_position = position;
		}
		
		void OnDeinitHandler(const int reason)
		{
			
		}
		
		void OnTickHandler()
		{
		   ManageTrailingStop();
		}
		
		void OnTimerHandler()
		{
		   
		}
		
		void OnTradeHandler()
		{
		   
		}	
		
		void Active()
		{
			_actived = true;
		}
		
		void Desactive()
		{
			_actived = false;
		}		
		
		bool IsActived()
		{
			return _actived;
		}		 
		
		void SetInicio(int value)
		{
			_start = value;
		}			
		
		int GetInicio()
		{
			return _start;
		}	
		
		void SetValor(int value)
		{
			_value = value;
		}			
		
		int GetValor()
		{
			return _value;
		}		
		
		int GetPositionType()
		{
			return (int)PositionGetInteger(POSITION_TYPE);
		}				
};