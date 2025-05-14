//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#ifndef __TYPES_TRADE_MQH__
#define __TYPES_TRADE_MQH__

struct SPositionInfo
   {
    int              ticket;
    double           lot;
    int              type;
    string           symbol;
    double           openPrice;
    double           closePrice;
    double           profit;
    double           stoplossPoint;
    double           takeProfitPoint;
    double           stoplossPrice;
    double           takeProfitPrice;
    datetime         openTime;
    datetime         closeTime;
    datetime         lastModify;
   };

#endif
//+------------------------------------------------------------------+
