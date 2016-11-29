//+------------------------------------------------------------------+
//|                                                           C6.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"  

#include <Trade\Trade.mqh>
#include <Trade\PositionInfo.mqh>
#include <Framework\Base.mqh>

class TheLineOfDivision : public Base
{
   private:   	                
         //Price   		
   		MqlRates _rates[];
         ENUM_TIMEFRAMES _period;
   		
   		//Estrategia
   		double _maxima;
   		double _minima;
   		
   		int _qtdCandles;
   		int _qtdToques;
   		double _tolerancia;
   		bool _waitBuy;
   		bool _waitSell;
   	   
   	   //Indicadores
   	   int _eMALongPeriod;
   	   int _eMALongHandle;
   	   double _eMALongValues[];   	   
   	   int _eMAShortPeriod;
   	   int _eMAShortHandle;
   	   double _eMAShortValues[];
   	     
   	   //Grafico 	   
   	   color _corBuy;
   	   color _corSell;
   	   color _cor;
   		bool _isDesenhar;
   		bool _isEnviarParaTras;
   		bool _isPreencher;
   		   	    	   
   public:
                
   		void SetQtdCandles(int qtd){
   		   _qtdCandles = qtd;
   		}
   		
   		void SetQtdToques(int qtd){
   		   _qtdToques = qtd;
   		}
   		
   		void SetTolerancia(double valor){
   		   _tolerancia = valor;
   		}   		   	
   		
   		void SetColor(color cor){
   		   _cor = cor;
   		}
   		
   		void SetIsDesenhar(bool isDesenhar){
   		   _isDesenhar = isDesenhar;
   		}
   		
   		void SetIsEnviarParaTras(bool isEnviarParaTras){
   		   _isEnviarParaTras = isEnviarParaTras;
   		}
   	   
   	   void SetIsPreencher(bool isPreencher){
   		   _isPreencher = isPreencher;
   		}
   		
   		void SetEMALongPeriod(int ema){
   			_eMALongPeriod = ema;
   		};
   		
   		void SetEMAShortPeriod(int ema){
   			_eMAShortPeriod = ema;
   		};
   		
   		void SetColorBuy(color cor){
   			_corBuy = cor;
   		};
   		
   		void SetColorSell(color cor){
   			_corSell = cor;
   		};   		   	
   		   		   
   		void Load(){
   		   		   		   			  
			   _eMALongHandle = iMA(GetSymbol(), GetPeriod(), _eMALongPeriod, 0, MODE_EMA, PRICE_CLOSE);
			   _eMAShortHandle = iMA(GetSymbol(), GetPeriod(), _eMAShortPeriod, 0, MODE_EMA, PRICE_CLOSE);
			   
			   if(_eMALongHandle < 0 || _eMAShortHandle < 0){
			      Alert("Erro ao criar indicadores: erro ", GetLastError(), "!");
			   }
   		};
   		
   		void Watch(){   		
   		      		  
   		   AtualizarLastPrice();
   		       		   	   		   		  
            if(HasPositionOpen()){
              GerenciarPosition(); 
              return;
            }                       
            
            if(!Validar()){
   		      return;
   		   }                                                                                       
            
            if(GetBuffers()){  
            
               ExcluirDesenho(_maxima);
               ExcluirDesenho(_minima); 
               
               bool isNewCandle =  IsNewCandle();            
               
               if(IsBuyCondition(isNewCandle)){                                
                  VerifyStrategy(ORDER_TYPE_BUY);
                  Desenhar(_maxima, _corBuy);
               }
               
               if(IsSellCondition(isNewCandle)){
                  VerifyStrategy(ORDER_TYPE_SELL);      
                  Desenhar(_minima, _corSell);
               }
   		   	 		   	
   		   	SetInfo("COMPRA "+(string)_maxima+" VENDA "+(string)_minima+
   		   	        "\nTOLERANCIA "+ (string)_tolerancia+ "PTS QTD "+(string)_qtdToques+" CANDLES");
   		   	ShowInfo();
   		   
   		   }
   		
   		};

         void VerifyStrategy(int order){
                                                                          
            if(order == ORDER_TYPE_BUY){
            
               double _entrada = _maxima + GetSpread();               
               double _auxStopGain = NormalizeDouble((_entrada + GetStopGain()), _Digits);
               double _auxStopLoss = NormalizeDouble((_entrada - GetStopLoss()), _Digits);              
                              
               if(GetLastPrice().last >= _entrada){                    
                  
                  if(!HasPositionOpen()){     
                     _waitBuy = false;
                     Buy(_entrada, _auxStopLoss, _auxStopGain, getNameRobot());
                  }                
                  
               }
               
               return;
                           
                                          
            }

            if(order == ORDER_TYPE_SELL){
            
               double _entrada = _minima - GetSpread();                                                                                                                                                 
               double _auxStopGain = NormalizeDouble((_entrada - GetStopGain()), _Digits);
               double _auxStopLoss = NormalizeDouble((_entrada + GetStopLoss()), _Digits);                              
                  
               if(GetLastPrice().last <= _entrada){                                     
                  
                  if(!HasPositionOpen()){
                     _waitSell = false;
                     Sell(_entrada, _auxStopLoss, _auxStopGain, getNameRobot());                                         
                  }                                    
                                                               
               }       
               
               return;
     
            }

         }
         
          bool IsBuyCondition(bool isNewCandle){  
          
            if(!isNewCandle){
               return _maxima != 0;
            }
                     
            bool isMatch = false;
            bool isFound = false;
            double auxMax = DBL_MIN;            
            double linha = DBL_MIN;            
            int maxCount = 0;              
            int auxMaxCount = 0;  
            _maxima = 0;         
                                   
            int maxIndexArray = _qtdCandles - 1;
                                                         
            for(int i = 0; i <= maxIndexArray; i++){   
                                                                
               auxMax = _rates[i].high;               
               auxMaxCount = 0;              
             
               for(int j = maxIndexArray; j > 0; j--){    
                                                                                                                                                              
                  if(_rates[j].high == auxMax){
                     auxMaxCount++;
                  }else if(_rates[j].high <= auxMax + _tolerancia && _rates[j].high >= auxMax - _tolerancia){
                     auxMaxCount++;
                  }                  
                  
                  if(_rates[j].high > auxMax + _tolerancia){
                     auxMaxCount = 0;
                  }                             
                           
                  isFound = auxMaxCount >= _qtdToques;                  
                  isFound = isFound && GetLastPrice().last <= auxMax; 
                                                    
                }                              
                
                if(isFound && auxMaxCount > maxCount){
                  maxCount = auxMaxCount;
                  linha = auxMax;
                  isMatch = true;
                }                                             
                                                                                                                                                                             
            }   
            
            if(isMatch){ 
               _maxima = linha + _tolerancia;
            }
            
            return isMatch;
            
         }
   
         bool IsSellCondition(bool isNewCandle){         
         
            if(!isNewCandle){
               return _minima != 0;
            }
                          
            bool isMatch = false;  
            bool isFound = false;                                                                          
            double auxMin = DBL_MAX;            
            double linha = DBL_MAX;
            int minCount = 0;              
            int auxMinCount = 0; 
            _minima = 0;                   
            
            int maxIndexArray = _qtdCandles - 1;
                                             
            for(int i = 0; i <= maxIndexArray; i++){   
                                                                
               auxMin = _rates[i].low;               
               auxMinCount = 0;              
             
               for(int j = maxIndexArray; j > 0; j--){    
                                                                                                                                                              
                  if(_rates[j].low == auxMin){
                     auxMinCount++;
                  }else if(_rates[j].low <= auxMin + _tolerancia && _rates[j].low >= auxMin - _tolerancia){
                     auxMinCount++;
                  } 
                  
                  if(_rates[j].low < auxMin - _tolerancia){
                     auxMinCount = 0;
                  }                             
                    
                  isFound = auxMinCount >= _qtdToques;
                  isFound = isFound && GetLastPrice().last >= auxMin;
                                 
                }                              
                
                if(isFound && auxMinCount > minCount){
                  minCount = auxMinCount;
                  linha = auxMin;
                  isMatch = true;
                }                                             
                                                                                                                                                                             
            }   
            
            if(isMatch){ 
               _minima = linha - _tolerancia; 
            }                                                                                                               		  
                                                                                                                         
            return isMatch;
         
         }  
                 
         void Desenhar(double price, color cor)
         {
            
            if(!_isDesenhar){
               return;
            }
            
            string objName = "LINE"+(string)price;
            ObjectCreate(0, objName, OBJ_HLINE, 0, 0, price);           
            
            ObjectSetInteger(0,objName,OBJPROP_COLOR, cor);
            ObjectSetInteger(0,objName,OBJPROP_BORDER_COLOR, clrBlack);
            ObjectSetInteger(0,objName,OBJPROP_STYLE, STYLE_SOLID);
            ObjectSetInteger(0,objName,OBJPROP_WIDTH, 1);  
            ObjectSetInteger(0,objName,OBJPROP_BACK, _isEnviarParaTras);
            ObjectSetInteger(0,objName,OBJPROP_FILL, _isPreencher);
            
            //ARROW PRICE
            objName = "SETA"+(string)price;
            ObjectCreate(0,objName,OBJ_ARROW_RIGHT_PRICE,0,_rates[0].time,price);
            ObjectSetInteger(0,objName,OBJPROP_COLOR, cor);
            ObjectSetInteger(0,objName,OBJPROP_BORDER_COLOR, clrBlack);
            ObjectSetInteger(0,objName,OBJPROP_STYLE, STYLE_SOLID);
            ObjectSetInteger(0,objName,OBJPROP_WIDTH, 2);  
            ObjectSetInteger(0,objName,OBJPROP_BACK, false);
            ObjectSetString(0,objName,OBJPROP_TEXT, "ENTRADA EM "+(string)price);
         }
         
         void ExcluirDesenho(double price){
                     
            if(!_isDesenhar){
               return;
            }
            
            ObjectDelete(0, "LINE"+(string)price);
            ObjectDelete(0, "SETA"+(string)price);
         }             
   			
   		bool GetBuffers(){
   		
   		   ZeroMemory(_eMALongValues);
   		   ZeroMemory(_eMAShortValues);
   		   ZeroMemory(_rates);
   		   
   		   ArraySetAsSeries(_eMALongValues, true);
   		   ArraySetAsSeries(_eMAShortValues, true);
   		   ArraySetAsSeries(_rates, true);
            
            int copiedMALongBuffer = CopyBuffer(_eMALongHandle, 0, 0, 15, _eMALongValues);
            int copiedMAShortBuffer = CopyBuffer(_eMAShortHandle, 0, 0, 15, _eMAShortValues);
            int copiedRates = CopyRates(GetSymbol(), GetPeriod(), 0, _qtdCandles, _rates);                               			                                   
            
            return copiedRates > 0 && copiedMALongBuffer > 0 && copiedMAShortBuffer > 0;    
   		
   		}
   		        
};

