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
		if(!GetIsRewrite()) return;

		Comment("--------------------------------------" +
			"\n" + GetRobotName() + " " + ToPeriodText(GetPeriod()) + " " + GetRobotVersion() + "\nFRAMEWORK " + version +
			(GetLastTextInfo() != NULL ? "\n--------------------------------------\n" + GetLastTextInfo() : "") +
			
			(!GetIsModeAlert() ?
			   "\n--------------------------------------" +
   			"\nVOLUME ATUAL " + GetPositionVolumeText() +
   			"\nTP " + DoubleToString(GetStopGain(), _Digits) + " SL " + DoubleToString(GetStopLoss(), _Digits)
   			: "\nMODO ALERTA ATIVADO"
			) + "\n--------------------------------------" +
			
			(GetIsStopOnLastCandle() ? "\nSTOP CANDLE ANTERIOR " + ToPeriodText(GetPeriodStopOnLastCandle()) : "") +
			
			(GetIsTrailingStop() ? "\nTRAILING STOP " + (string)(GetPositionType() == POSITION_TYPE_SELL ? 
			                                                 GetPositionPriceOpen() - GetTrailingStopInicio() : 
			                                                 GetPositionPriceOpen() + GetTrailingStopInicio()) + " " + DoubleToString(GetTrailingStop(), _Digits) : "") +
			                                                 
			(GetIsBreakEven() ? "\nBREAK EVEN " + (GetIsBreakEvenExecuted() ? "" : (string)(GetPositionType() == POSITION_TYPE_SELL ? 
			                                                                        GetPositionPriceOpen() - GetBreakEven() :
			                                                                        GetPositionPriceOpen() + GetBreakEven())) : "") +
			(GetIsParcial() ? "\nPARCIAL " + 
				(!GetIsPrimeiraParcial() && GetPrimeiraParcialInicio() > 0 ? DoubleToString((GetPositionType() == POSITION_TYPE_SELL ? 
				                                                                     GetPositionPriceOpen() - GetPrimeiraParcialInicio() : 
				                                                                     GetPositionPriceOpen() + GetPrimeiraParcialInicio()), _Digits) + " " + (string)GetPrimeiraParcialVolume() + " " : "") +
				                                                                     
				(!GetIsSegundaParcial() && GetSegundaParcialInicio() > 0 ? " | " + DoubleToString((GetPositionType() == POSITION_TYPE_SELL ? 
				                                                                           GetPositionPriceOpen() - GetSegundaParcialInicio() : 
				                                                                           GetPositionPriceOpen() + GetSegundaParcialInicio()), _Digits) + " " + (string)GetSegundaParcialVolume() + " " : "") +
				                                                                           
				(!GetIsTerceiraParcial() && GetTerceiraParcialInicio() > 0 ? " | " + DoubleToString((GetPositionType() == POSITION_TYPE_SELL ? 
				                                                                             GetPositionPriceOpen() - GetTerceiraParcialInicio() : 
				                                                                             GetPositionPriceOpen() + GetTerceiraParcialInicio()), _Digits) + " " + (string)GetTerceiraParcialVolume() + " "  : "") 
			: "") +
			
			(GetIsGerenciamentoFinanceiro() ? "\nPROFIT " + (string)GetTotalLucro() : "") +
			
			"\n--------------------------------------" +

			("\n" + GetLogger().Get()));

	}
		
	public:
	
		BadRobotPrompt(){
					
		}					
};