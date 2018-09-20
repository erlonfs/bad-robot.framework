//+------------------------------------------------------------------+
//|                                   Copyright 2018, Erlon F. Souza |
//|                                       https://github.com/erlonfs |
//+------------------------------------------------------------------+

#property copyright "Copyright 2018, Erlon F. Souza"
#property link      "https://github.com/erlonfs"
#property version    "1.0.0"

#include <BadRobot.Framework\BadRobotCore.mqh>

class BadRobotPrompt : public BadRobotCore
{
	private:
		
		
	protected:
	
	void ShowInfo()
	{					
		if(!_isRewrite) return;

		Comment("--------------------------------------" +
			"\n" + GetRobotName() + " " + ToPeriodText(_period) + " " + GetRobotVersion() + "\nFRAMEWORK " + version +
			(_lastTextInfo != NULL ? "\n--------------------------------------\n" + _lastTextInfo : "") +
			
			(!_isAlertMode ?
			   "\n--------------------------------------" +
   			"\nVOLUME ATUAL " + (HasPositionOpen() ? (GetPositionType() == POSITION_TYPE_SELL ? "-" : "") + (string)GetPositionVolume() : "0") +
   			"\nTP " + DoubleToString(_stopGain, _Digits) + " SL " + DoubleToString(_stopLoss, _Digits)
   			: "\nMODO ALERTA ATIVADO"
			) + "\n--------------------------------------" +
			
			(_isStopOnLastCandle ? "\nSTOP CANDLE ANTERIOR " + ToPeriodText(_periodStopOnLastCandle) : "") +
			
			(_isTrailingStop ? "\nTRAILING STOP " + (string)(GetPositionType() == POSITION_TYPE_SELL ? 
			                                                 GetPositionPriceOpen() - _trailingStopInicio : 
			                                                 GetPositionPriceOpen() + _trailingStopInicio) + " " + DoubleToString(_trailingStop, _Digits) : "") +
			                                                 
			(_isBreakEven ? "\nBREAK EVEN " + (_isBreakEvenExecuted ? "" : (string)(GetPositionType() == POSITION_TYPE_SELL ? 
			                                                                        GetPositionPriceOpen() - _breakEven :
			                                                                        GetPositionPriceOpen() + _breakEven)) : "") +
			(_isParcial ? "\nPARCIAL " + 
				(!_isPrimeiraParcial && _primeiraParcialInicio > 0 ? DoubleToString((GetPositionType() == POSITION_TYPE_SELL ? 
				                                                                     GetPositionPriceOpen() - _primeiraParcialInicio : 
				                                                                     GetPositionPriceOpen() + _primeiraParcialInicio), _Digits) + " " + (string)_primeiraParcialVolume + " " : "") +
				                                                                     
				(!_isSegundaParcial && _segundaParcialInicio > 0 ? " | " + DoubleToString((GetPositionType() == POSITION_TYPE_SELL ? 
				                                                                           GetPositionPriceOpen() - _segundaParcialInicio : 
				                                                                           GetPositionPriceOpen() + _segundaParcialInicio), _Digits) + " " + (string)_segundaParcialVolume + " " : "") +
				                                                                           
				(!_isTerceiraParcial && _terceiraParcialInicio > 0 ? " | " + DoubleToString((GetPositionType() == POSITION_TYPE_SELL ? 
				                                                                             GetPositionPriceOpen() - _terceiraParcialInicio : 
				                                                                             GetPositionPriceOpen() + _terceiraParcialInicio), _Digits) + " " + (string)_terceiraParcialVolume + " "  : "") 
			: "") +
			
			(_isGerenciamentoFinanceiro ? "\nPROFIT " + (string)GetTotalLucro() : "") +
			
			"\n--------------------------------------" +

			("\n" + _logger.Get()));

	}
		
	public:
	
		BadRobotPrompt(){
					
		}					
};