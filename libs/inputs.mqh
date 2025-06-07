//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#ifndef __INPUTS_MQH__
#define __INPUTS_MQH__

#include "types.mqh"
#include "commons.mqh"
#include "tools/logger.mqh"

input string Fast_MA_Settings = "----- Fast MA Settings -----";
input int Fast_MA_Period = 7;
input ENUM_MA_METHOD Fast_MA_Method = MODE_SMA;
input ENUM_APPLIED_PRICE Fast_MA_Applied = PRICE_CLOSE;

input string Slow_MA_Settings = "----- Slow MA Settings -----";
input int Slow_MA_Period = 21;
input ENUM_MA_METHOD Slow_MA_Method = MODE_SMA;
input ENUM_APPLIED_PRICE Slow_MA_Applied = PRICE_CLOSE;

input string Trade_Settings = "----- Trade Settings -----";
input ENUM_LOT_SIZE_MODE LotSizeMode = LOT_BY_BALANCE; // Lot size calculation mode
input double LotSizeFixed = 0.01;                      // Fixed lot size
input int Money_Percent = 1;
input int StopLoss = 200;
input int TakeProfit = 600;
input int Slippage = 20;
input ENUM_TIMEFRAMES Timeframe = PERIOD_M1;
input int MagicNumber = 1111;
input string TradingStartTime = "01:00:00";
input string TradingEndTime = "19:00:00";
input ENUM_LogLevel logLevel = LOG_DEBUG;

#endif
//+------------------------------------------------------------------+
