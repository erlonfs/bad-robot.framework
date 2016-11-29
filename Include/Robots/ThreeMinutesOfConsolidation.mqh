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

class ThreeMinutesOfConsolidation : public Base
{
   private:   	                   
         //Price   		
   		MqlRates _rates[];
   		
   		//Estrategia
   		double _maxima;
   		double _minima;
   		int _lastCountCandles;
   		int _qtdCandleConsolidacao;
   		double _tamanhoMaxPrecoCandle;
   		bool _wait;
   	   datetime _timeMatch;
   	   int _positionMatch;
   	   
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
                            		
   		void SetQtdCandleConsolidacao(int qtd){
   		   _qtdCandleConsolidacao = qtd;
   		}
   		
   		void SetTamanhoMaxPrecoCandle(double preco){
   		   _tamanhoMaxPrecoCandle = preco;
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
			   _eMALongHandle = iMA(GetSymbol(), PERIOD_M1, _eMALongPeriod, 0, MODE_EMA, PRICE_CLOSE);
			   _eMAShortHandle = iMA(GetSymbol(), PERIOD_M1, _eMAShortPeriod, 0, MODE_EMA, PRICE_CLOSE);
			   
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
                   
               /*O Metodo "Match()" renova a minima e maxima, usar o operar "OU" excludente com o metodo apos a verificação da variavel "_wait"*/       	
   		   	if(_wait || Match()){   		   	      		   	  
   		   	   
   		   	   _wait = true;   		   	   
   		   	      		   	   
   		   	   double _auxStopGainBuy = NormalizeDouble((_maxima + GetStopGain()), _Digits);
   		   	   double _auxStopGainSell = NormalizeDouble((_minima - GetStopGain()), _Digits);
   		   	   
   		   	   Desenhar(_minima, _timeMatch, _maxima, GetLastPrice().time);
                                    
                  if(_maxima - GetLastPrice().last < GetLastPrice().last - _minima && BuyCondition(_auxStopGainBuy)){
                     AtualizarDesenho(_corBuy);
                  }else if(_maxima - GetLastPrice().last > GetLastPrice().last - _minima && SellCondition(_auxStopGainSell)){
                     AtualizarDesenho(_corSell);
                  }
                  else{
                     AtualizarDesenho(_cor);
                  }
                  
                  VerifyStrategy(ORDER_TYPE_BUY);                  
                  VerifyStrategy(ORDER_TYPE_SELL);                  
                                    
   		   	}   		   	
   		   	
   		   	ShowInfo();
   		   
   		   }
   		
   		};

         void VerifyStrategy(int order){
                                                                          
            if(order == ORDER_TYPE_BUY){
            
               double _entrada = _maxima + GetSpread();               
               double _auxStopGain = NormalizeDouble((_entrada + GetStopGain()), _Digits);
               double _auxStopLoss = NormalizeDouble((_entrada - GetStopLoss()), _Digits);   
               
               bool condition = BuyCondition(_auxStopGain);
                              
               if(GetLastPrice().ask >= _entrada){  
                  
                  condition = BuyCondition(_auxStopGain);
                  
                  if(!HasPositionOpen() && condition){     
                     _wait = false;
                     Buy(_entrada, _auxStopLoss, _auxStopGain, getNameRobot()); 
                     
                     //Executar recursos adicionais somente apos atribuir "_wait = false", pois o OnTick executa multi-threads
                     AtualizarDesenho(_corBuy);
                     
                  } else{
                     _wait = false;
                     AtualizarDesenho(_cor);
                  }                 
                  
               }
               
               return;
                           
                                          
            }

            if(order == ORDER_TYPE_SELL){   
            
               double _entrada = _minima - GetSpread();                                                                                                                                                 
               double _auxStopGain = NormalizeDouble((_entrada - GetStopGain()), _Digits);
               double _auxStopLoss = NormalizeDouble((_entrada + GetStopLoss()), _Digits);
               
               bool condition = SellCondition(_auxStopGain);
                  
               if(GetLastPrice().bid <= _entrada){   
                  
                  condition = SellCondition(_auxStopGain);                  
                  
                  if(!HasPositionOpen() && condition){                     
                     _wait = false;
                     Sell(_entrada, _auxStopLoss, _auxStopGain, getNameRobot());
                     
                     //Executar recursos adicionais somente apos atribuir "_wait = false", pois o OnTick executa multi-threads
                     AtualizarDesenho(_corSell);
                                          
                  }else{
                     _wait = false;
                     AtualizarDesenho(_cor);
                  }
                  
                  
                                                               
               }       
               
               return;
     
            }

         }
   
         bool Match(){ 
                     
            if(!IsNewCandle()){
               return false;
            }
              
            bool isMatch = false;           
            
            _maxima = _rates[14].high;
            _minima = _rates[14].low;
            _timeMatch = _rates[14].time;
            _positionMatch = 14;
            
            int countCandles = 0;
            
            for(int i = 14; i > 0; i--){
                          
               if(GetLastPrice().last >= _minima && GetLastPrice().last <= _maxima){
                  isMatch = true;
               }
               
               if(_rates[i].low < _minima || _rates[i].high > _maxima){
                  isMatch = false;
               }
               
               if(_maxima - _minima > _tamanhoMaxPrecoCandle){
                  isMatch = false;
               } 
               
               if(isMatch){
                  countCandles++;
               }else{
                  _minima = _rates[i].low;
                  _maxima = _rates[i].high;
                  
                  ExcluirDesenho(_timeMatch);
                  _timeMatch = _rates[i].time;
                  _positionMatch = i;
                  countCandles = 0;
               }                                             
            
            }
          
            if(isMatch && GetLastPrice().last >= _minima && GetLastPrice().last <= _maxima){              
               isMatch = countCandles >= _qtdCandleConsolidacao;               
            }
                 
            if(countCandles > 0 && countCandles <= _qtdCandleConsolidacao){
               ShowMessage("Consolidação de " + (string)countCandles + " Candle(s). Aguarde configuração de padrão.");
            }else{
               if(_lastCountCandles > 0 && _lastCountCandles < _qtdCandleConsolidacao){
                  ShowMessage("O Padrão foi desconfigurado.");
               }
            }
            if(countCandles != _lastCountCandles){
               _lastCountCandles = countCandles;
            }                        
            
            if(isMatch){
               Desenhar(_minima, _timeMatch, _maxima, GetLastPrice().time);
               ShowMessage("COMPRA EM "+(string)_maxima+" VENDA EM "+(string)_minima);
            }  
            
            SetInfo("MIN "+(string)_minima+" MAX "+(string)_maxima + 
                    "\nQTD CANDLES "+(string)_qtdCandleConsolidacao+" TAM. MAX. CANDLE "+(string)_tamanhoMaxPrecoCandle+"PTS");      		  
                                                                                                                         
            return isMatch;
         
         }  
         
         
         void Desenhar(double vprice1, datetime time1, double vprice2, datetime time2)
         {            
            if(!_isDesenhar){
               return;
            }
            
            ExcluirDesenho(time1);
            string objName = "RECT"+(string)time1;
            ObjectCreate(0,objName,OBJ_RECTANGLE,0,time1,vprice1,time2,vprice2);           
            
            ObjectSetInteger(0,objName,OBJPROP_COLOR, _cor);
            ObjectSetInteger(0,objName,OBJPROP_BORDER_COLOR, clrBlack);
            ObjectSetInteger(0,objName,OBJPROP_STYLE,STYLE_DASH);
            ObjectSetInteger(0,objName,OBJPROP_WIDTH,2);  
            ObjectSetInteger(0,objName,OBJPROP_BACK,_isEnviarParaTras);
            ObjectSetInteger(0,objName,OBJPROP_FILL,_isPreencher);
         }
         
         void ExcluirDesenho(datetime time){
                     
            if(!_isDesenhar){
               return;
            }
            
            string objName = "RECT"+(string)time;
            
            if (ObjectFind(0, objName) != 0){
               ObjectDelete(0, objName);
            }
         }
         
         void AtualizarDesenho(color cor){
                     
            if(!_isDesenhar){
               return;
            }
                        
            ObjectSetInteger(0,"RECT"+(string)_timeMatch ,OBJPROP_COLOR, cor);
            
         }
   			
   		bool BuyCondition(double StopGain){
   		   
   		   double auxSpread = GetSpread() * 2;
   		   bool condition = true;
   		   int index = _positionMatch;
   		   	
		      if(_maxima < _eMALongValues[index]){
		         if(StopGain + GetSpread() > _eMALongValues[index]){
		            condition = false;
		         }
		      }
		      
		      if(_maxima < _eMALongValues[index] + auxSpread && _maxima > _eMALongValues[index] - auxSpread){
		         condition = false;
		      }
		      
		      if(_maxima < _eMAShortValues[index]){
		         condition = false;
		      }		      
   		         
   		   return condition;
   		   
   		}
   		
   		bool SellCondition(double StopGain){
   		   		     		      		     		      		
   		   double auxSpread = GetSpread() * 2;   		
   		   bool condition = true;
   		   int index = _positionMatch;
   		   	
		      if(_minima > _eMALongValues[index]){
		         if(StopGain - GetSpread() < _eMALongValues[index]){
		            condition = false;
		         }
		      }
		      
		      if(_minima > _eMALongValues[index] - auxSpread && _minima < _eMALongValues[index] + auxSpread){
		         condition = false;
		      }
		      
		      if(_minima > _eMAShortValues[index]){
		         condition = false;
		      }		      
   		         
   		   return condition;
   		   
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
            int copiedRates = CopyRates(GetSymbol(), GetPeriod(), 0, 15, _rates);                               			                        
            
            return copiedRates > 0 && copiedMALongBuffer > 0 && copiedMAShortBuffer > 0;
   		
   		}   		   		
   
};
