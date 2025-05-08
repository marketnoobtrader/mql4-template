//+------------------------------------------------------------------+
//|                                        TimeHandlerExample.mq4 |
//|                                       Copyright 2025, Your Name |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Your Name"
#property link "https://www.mql5.com"
#property version "1.00"
#property strict

#include "time-handler.mqh"

input string TradingStartTime = "01:30:00";
input string TradingEndTime = "02:00:00";

EnhancedTimeHandler *g_timeHandler = NULL;
NewCandleObserver g_currentCandle(PERIOD_CURRENT);
NewCandleObserver g_15mCandle(PERIOD_M15);

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
   {
    g_timeHandler = new EnhancedTimeHandler(TradingStartTime, TradingEndTime);
    return (INIT_SUCCEEDED);
   }

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
   {
    if(g_timeHandler != NULL)
       {
        delete g_timeHandler;
        g_timeHandler = NULL;
       }
   }

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
   {
    if(g_currentCandle.IsNewCandle())
       {
        Print("current=> New candle detected at ", TimeToString(g_currentCandle.GetCandleTime()));
       }
    if(g_15mCandle.IsNewCandle())
       {
        Print("15m=> New candle detected at ", TimeToString(g_15mCandle.GetCandleTime()));
       }
    if(g_timeHandler.IsWithinTradingHours())
       {
        static datetime lastDebugTime = 0;
        datetime currentTime = TimeCurrent();
        if(currentTime - lastDebugTime >= 60)
           {
            Print("Trading is active.");
            lastDebugTime = currentTime;
           }
       }
   }
//+------------------------------------------------------------------+
