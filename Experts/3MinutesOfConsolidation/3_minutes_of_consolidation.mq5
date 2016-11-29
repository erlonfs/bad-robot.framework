//+------------------------------------------------------------------+
//|                                                     ExpertC6.mq5 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright     "Copyright 2016, Erlon F Souza."
#property link          "www.facebook.com/erlonfs"
#property version       "1.00"
#property description   "Utiliza o setup de consolidação de 3 candlestick em tempo gráfico de 3 min para mini dolar/mini indice.O programa exibi marcações em tela durante as analises. Quando o mesmo gerar uma area com cor neutra (cinza por definição), significa que não existe operação a realizar. Em marcações de cor vermelha (padrão), o mesmo espera uma entrada em venda descoberta, em marcações de cor azul (cor pre-definida) o programa espera uma entrada em compra.\n\n\nBons trades!\n\nEquipe BAD ROBOT.\nerlon.efs@gmail.com"
#property icon          "3_minutes_of_consolidation.ico";  
#define   robot_name    "3 MINUTES OF CONSOLIDATION"

#include <Robots\ThreeMinutesOfConsolidation.mqh>
#include <Framework\Enum.mqh>

input string          Secao1 = "###############";//### Definições Básicas ###
input string          HoraInicio="00:00";//Hora de início de execução da estratégia
input string          HoraFim="00:00";//Hora de término de execução da estratégia
input string          HoraInicioIntervalo="00:00";//Hora de início intervalo de execução da estratégia
input string          HoraFimIntervalo="00:00";//Hora de término intervalo de execução da estratégia
input ENUM_LOGIC      FecharPosition=0;//Fechar posições ao término de horario de execução?
input int             Volume=0; //Volume
input double          Spread = 0;//Spread utilizado nos rompimento

input string          Secao2 = "###############";//### Alvos ###
input double          StopGainEmPontos=0; //Stop Gain em Pontos
input double          StopLossEmPontos=0; //Stop Loss em Pontos

input string          Secao3 = "###############";//### Trailing Stop ###
input ENUM_LOGIC      IsTrailingStop=0;//Ativar recurso de Trailing Stop?
input double          TrailingStopInicio=0; //Valor de inicio do ajuste
input double          TrailingStop=0; //Valor de Ajuste do Trailing Stop

input string          Secao4 = "###############";//### Break-Even ###
input ENUM_LOGIC      IsBreakEven=0;//Ativar recurso de Break-Even?
input double          BreakEven=0;//Qtd Pontos Acima do Break-Even
input double          BreakEvenInicio=0;//Valor de inicio do Break-Even

input string          Secao5 = "###############";//### Config de Apresentação ###
input ENUM_LOGIC      IsDesenhar=0;//Desenhar marcações?
input ENUM_LOGIC      IsPreencher=0;//Preencher?
input ENUM_LOGIC      IsEnviarParaTras=0;//Enviar para Trás?
input color           Cor=clrDimGray;//Cor utilizada em marcaçoes nulas
input color           CorCompra=C'3,95,172';//Cor utilizada em marcações de Compra
input color           CorVenda=C'225,68,29';//Cor utilizada em marcações de Venda

input string          Secao6 = "###############";//### Financeiro ###
input ENUM_LOGIC      IsGerenciamentoFinanceiro=0;//Ativar Gerenciamento Financeiro?
input double          CorretagemValor=0.0; //Valor de Corretagem por contrato
input ENUM_LOGIC      IsCalcularCorretagemLucroMaximo=0;//Calcular valor máximo de lucro com corretagem incluso?
input double          MaximoLucroDiario=0; //Valor Máximo de lucro no dia
input double          MaximoPrejuizoDiario=0; //Valor Máximo de prejuizo no dia

input string          Secao7 = "###############";//### Realização de Parcial ###
input ENUM_LOGIC      IsParcial=0;//Ativar recurso de Parcial?
input double          PrimeiraParcialLotes=0;//Qtd de lotes da 1ª parcial
input double          PrimeiraParcialInicio=0;//Valor de inicio da 1ª parcial
input double          SegundaParcialLotes=0;//Qtd de lotes da 2ª parcial
input double          SegundaParcialInicio=0;//Valor de inicio da 2ª parcial
input double          TerceiraParcialLotes=0;//Qtd de lotes da 3ª parcial
input double          TerceiraParcialInicio=0;//Valor de inicio da 3ª parcial

input string          Secao8 = "###############";//### Expert Control ###
input int             NumeroMagico=0; //Número mágico

input string          Secao9 = "###############";//### Config de Estratégia ###
input int             MediaLonga=0;//Média longa utilizada no periodo de 1 min
input int             MediaCurta=0;//Média curta utilizada no periodo de 1 min
input double          TamanhoMaximoCandle = 0;//Tamanho máx. candle consolidacao
input int             QuantidadeCandlesConsolidacao = 0;//quantidade de candles usados na consolidacao de 3 min

//variaveis
ThreeMinutesOfConsolidation _ea;

int OnInit(){  
           
   printf("Bem Vindo ao "+robot_name+"!");
  
   _ea.SetSymbol(_Symbol);
   _ea.SetLotes(Volume);
   _ea.SetSpread(Spread);
   _ea.SetHoraInicio(HoraInicio);
   _ea.SetHoraFim(HoraFim);
   _ea.SetHoraInicioIntervalo(HoraInicioIntervalo);
   _ea.SetHoraFimIntervalo(HoraFimIntervalo);
   _ea.SetIsClosePosition(FecharPosition);
   _ea.SetIsTrailingStop(IsTrailingStop);
   _ea.SetIsBreakEven(IsBreakEven);
   _ea.SetColor(Cor);
   _ea.SetColorBuy(CorCompra);
   _ea.SetColorSell(CorVenda);      
   _ea.SetCorretagemValor(CorretagemValor);
   _ea.SetIsCalcularCorretagemValoresMaximosDiarios(IsCalcularCorretagemLucroMaximo);   
   _ea.SetStopGain(StopGainEmPontos);
   _ea.SetStopLoss(StopLossEmPontos);
   _ea.SetTrailingStopInicio(TrailingStopInicio);
   _ea.SetTrailingStop(TrailingStop);   
   _ea.SetBreakEven(BreakEven);
   _ea.SetBreakEvenInicio(BreakEvenInicio);
   _ea.SetIsGerenciamentoFinanceiro(IsGerenciamentoFinanceiro);
   _ea.SetMaximoLucroDiario(MaximoLucroDiario);
   _ea.SetMaximoPrejuizoDiario(MaximoPrejuizoDiario);   
   _ea.SetIsDesenhar(IsDesenhar);
   _ea.SetIsEnviarParaTras(IsEnviarParaTras);
   _ea.SetIsPreencher(IsPreencher);
   _ea.SetIsParcial(IsParcial);
   _ea.SetPrimeiraParcialLotes(PrimeiraParcialLotes);
   _ea.SetPrimeiraParcialInicio(PrimeiraParcialInicio);   
   _ea.SetSegundaParcialLotes(SegundaParcialLotes);
   _ea.SetSegundaParcialInicio(SegundaParcialInicio);   
   _ea.SetTerceiraParcialLotes(TerceiraParcialLotes);
   _ea.SetTerceiraParcialInicio(TerceiraParcialInicio);   
   _ea.SetNumberMagic(NumeroMagico);
   
   //Estratégia
   _ea.SetQtdCandleConsolidacao(QuantidadeCandlesConsolidacao);
   _ea.SetEMALongPeriod(MediaLonga);
   _ea.SetEMAShortPeriod(MediaCurta);
   _ea.SetTamanhoMaxPrecoCandle(TamanhoMaximoCandle);
   _ea.SetPeriod(PERIOD_M3);
   _ea.SetNameRobot(robot_name);
        
 	_ea.Load(); 

   return(INIT_SUCCEEDED);

}

void OnDeinit(const int reason){
   printf("Obrigado por utilizar o "+robot_name+"!");
}

void OnTick(){                                                             
    _ea.Watch();            
}
