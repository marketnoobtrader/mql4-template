//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+

#property copyright "Copyright 2021, MQL4club Software"
#property link "https://t.me/pip_to_pip"
#property version "2.0"
#property strict

#include <stdlib.mqh>
#include "libs/tools/logger.mqh"
#include "libs/tools/comment-info.mqh"
#include "libs/tools/time-handler.mqh"
#include "libs/trade/trade-manager.mqh"
#include "libs/strategy/strategy1.mqh"
#include "libs/order/TradingSystem.mqh"

//+-------------------------------+
//| Input Parameters              |
//+-------------------------------+
input string Fast_MA_Settings = "----- Fast MA Settings -----";
input int Fast_MA_Period = 7;
input ENUM_MA_METHOD Fast_MA_Method = MODE_SMA;
input ENUM_APPLIED_PRICE Fast_MA_Applied = PRICE_CLOSE;

input string Slow_MA_Settings = "----- Slow MA Settings -----";
input int Slow_MA_Period = 21;
input ENUM_MA_METHOD Slow_MA_Method = MODE_SMA;
input ENUM_APPLIED_PRICE Slow_MA_Applied = PRICE_CLOSE;

input string Trade_Settings = "----- Trade Settings -----";
input double LotSize = 0.01;
input int StopLoss = 200;
input int TakeProfit = 600;
input int Slippage = 20;
input ENUM_TIMEFRAMES Timeframe = PERIOD_M1;
input int MagicNumber = 1111;
input string TradingStartTime = "01:00:00";
input string TradingEndTime = "19:00:00";
input ENUM_LogLevel logLevel = LOG_DEBUG;

//+-------------------------------+
//| Global Instance               |
//+-------------------------------+
CLogger *logger;
CTradingSystem *g_tradingSystem = new CTradingSystem(LotSize, Slippage, StopLoss, TakeProfit);
MaCrossoverStrategy* strategy = new MaCrossoverStrategy(g_tradingSystem);
BotController bot(strategy);
NewCandleObserver g_currentCandle(PERIOD_CURRENT);
EnhancedTimeHandler *g_timeHandler = NULL;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
   {
    ResetLastError();
    logger = CLogger::GetInstance();
    logger.setLevel(logLevel);
    logger.log(LOG_DEBUG, "bot started!!");
    g_timeHandler = new EnhancedTimeHandler(TradingStartTime, TradingEndTime);
    return INIT_SUCCEEDED;
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
   {
    commentInfo();
    if(g_currentCandle.IsNewCandle() && g_timeHandler.IsWithinTradingHours())
       {
        bot.OnNewTick();
       }
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
   {
    if(g_timeHandler != NULL)
       {
        delete g_timeHandler;
        g_timeHandler = NULL;
       }
    delete logger;
    logger = NULL;
    delete g_tradingSystem;
    g_tradingSystem = NULL;
    delete strategy;
    strategy = NULL;
    const int errorCode = GetLastError();
    if(errorCode != ERR_NO_ERROR)
       {
        const string errorMsg = ErrorDescription(errorCode);
        Print("==========================");
        PrintFormat("[!]Last Error in %s: #%d >> %s", __FUNCTION__, errorCode, errorMsg);
       }
   }

//+------------------------------------------------------------------+
