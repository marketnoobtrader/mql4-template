//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#ifndef __COMMONS_MQH__
#define __COMMONS_MQH__

#include "types.mqh"
#include "inputs.mqh"
#include "order/TradeUtils.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double getLotSize()
   {
    double accountValue;
    switch(LotSizeMode)
       {
        case LOT_FIXED:
            return LotSizeFixed;
        case LOT_BY_BALANCE:
            accountValue = NormalizeDouble(AccountBalance(), 2);
            break;
        case LOT_BY_EQUITY:
            accountValue = NormalizeDouble(AccountEquity(), 2);
            break;
        default:
            return LotSizeFixed;
       }
    return CTradeUtils::CalculateLotSize(Money_Percent, StopLoss, accountValue);
   }



//+------------------------------------------------------------------+
//| Generate a unique object name                                    |
//| Format: <objectPrefix>-<timeOrRand3>-<rand6>                     |
//+------------------------------------------------------------------+
string GenerateRandomObjectName(const string &objectPrefix, int indexTime = -1)
   {
    string timeOrRandom;
    if(indexTime >= 0 && indexTime < Bars)
       {
        datetime barTime = Time[indexTime];
        timeOrRandom = IntegerToString((int)barTime);
       }
    else
       {
        int rand3 = 100 + MathRand() % 900; // Random 3-digit number
        timeOrRandom = IntegerToString(rand3);
       }
    int rand6 = 100000 + MathRand() % 900000; // Random 6-digit number
    return objectPrefix + "-" + timeOrRandom + "-" + IntegerToString(rand6);
   }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
datetime FindBarTimeByPriceRange(double price1, datetime fromTime, double price2 = 0)
   {
    const int startIndex = iBarShift(NULL, 0, fromTime) - 1;
    double high, low;
    bool p1InRange, p2InRange;
    for(int i = startIndex; i >= 0; i--)
       {
        high = High[i];
        low  = Low[i];
        p1InRange = (price1 >= low && price1 <= high);
        p2InRange = (price2 >= low && price2 <= high);
        if(p1InRange || p2InRange)
           {
            return Time[i] + Period() * 60;
           }
       }

    return 0;
   }






//+------------------------------------------------------------------+
//| Get high and low price within a candle range                     |
//+------------------------------------------------------------------+
void GetHighLowBetweenCandles(int index1, int index2, double &highest, double &lowest) //, bool &bullishFlag)
   {

    int minIndex = MathMin(index1, index2);
    int maxIndex = MathMax(index1, index2);

    highest = High[minIndex];
    lowest = Low[minIndex];

    int highestIndex = 0;
    int lowestIndex = 0;
    for(int i = minIndex + 1; i <= maxIndex; i++)
       {
        if(High[i] > highest)
           {

            highestIndex = i;
            highest = High[i];
           }
        if(Low[i] < lowest)
           {
            lowestIndex = i;
            lowest = Low[i];
           }
       }


//bullishFlag = highestIndex < lowestIndex ? false : true;
   }



#endif
//+------------------------------------------------------------------+
