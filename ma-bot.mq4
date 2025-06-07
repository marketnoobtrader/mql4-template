//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+

#property copyright "Copyright 2021, MQL4club Software"
#property link "https://t.me/pip_to_pip"
#property version "6.0"
#property strict

#include <stdlib.mqh>
#include "libs/tools/logger.mqh"
#include "libs/tools/comment-info.mqh"
#include "libs/tools/time-handler.mqh"
#include "libs/trade/trade-manager.mqh"
#include "libs/strategy/strategy1.mqh"
#include "libs/order/TradingSystem.mqh"
#include "libs/types.mqh"
#include "libs/inputs.mqh"
#include "libs/commons.mqh"

//+-------------------------------+
//| Global Instance               |
//+-------------------------------+
CLogger *logger;
CTradingSystem *g_tradingSystem = new CTradingSystem(getLotSize(), Slippage, StopLoss, TakeProfit);
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
    logger.log(LOG_DEBUG, "getLotSize(): " + (string)getLotSize());
    g_timeHandler = new EnhancedTimeHandler(TradingStartTime, TradingEndTime);

    return INIT_SUCCEEDED;
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
   {
    commentInfo();

    if(!(g_currentCandle.IsNewCandle() && g_timeHandler.IsWithinTradingHours()))
        return;

    if(LotSizeMode == LOT_BY_EQUITY)
        g_tradingSystem.setLotSize(getLotSize());

    bot.OnNewTick();

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
