//+------------------------------------------------------------------+
//|                                                  Bolling RSI.mq4 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#property strict
//--- input parameters
input int      TakeProfit=50;
input int      StopLoss = 0;
input double      LotSize = 0.01;
int counter = 0;
int sl;
int swap_long;
int swap_short;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
  sl = (int)MarketInfo(Symbol(),MODE_STOPLEVEL) + MarketInfo(Symbol(),MODE_SPREAD);
  swap_long = (int)MarketInfo(Symbol(),MODE_SWAPLONG);
  swap_short = (int)MarketInfo(Symbol(),MODE_SWAPSHORT);
  Alert("This is swap long: ",swap_long);
  Alert("This is swap short: ",swap_short);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   string signal = "";
   // getting RSI value
   double rsiValue = iRSI(Symbol(),0,14,PRICE_CLOSE,0);
   // getting value for bands candle one
   double lowerBandValueF = iBands(Symbol(),0,20,2,0,PRICE_CLOSE,MODE_LOWER,1);
   double upperBandValueF = iBands(Symbol(),0,20,2,0,PRICE_CLOSE,MODE_UPPER,1);
   // getting value for bands candle two
   double lowerBandValueS = iBands(Symbol(),0,20,2,0,PRICE_CLOSE,MODE_LOWER,2);
   double upperBandValueS = iBands(Symbol(),0,20,2,0,PRICE_CLOSE,MODE_UPPER,2);
   if (OrdersTotal() < 1)
   {
     if(Ask > Close[1] && Close[2] < lowerBandValueS && Close[1] > lowerBandValueF && rsiValue < 30)
     {
      counter += 1;
       int buy = OrderSend(Symbol(),OP_BUY,0.1,Ask,3,0/*Ask - (sl * _Point) - (100 * _Point)*/,Ask +(Ask - Bid)+ (10 * _Point) + (swap_long * _Point),NULL,0,0,Green);
     }
     else if(Bid < Close[1] && Close[2] > upperBandValueS && Close[1] < upperBandValueF && rsiValue > 70)
     {
       int sell = OrderSend(Symbol(),OP_SELL,0.1,Bid,3,0/*Bid + (sl * _Point) + (100 * _Point)*/,Bid - (Ask - Bid) - (10 * _Point) - (swap_short * _Point),NULL,0,0,Red);        
     }
   }
  }
//+------------------------------------------------------------------+
