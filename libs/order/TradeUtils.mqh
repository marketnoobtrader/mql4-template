//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#ifndef __TRADE_UTILS_MQH__
#define __TRADE_UTILS_MQH__

#include "OrderManagerConstants.mqh"

//+------------------------------------------------------------------+
//| Utility functions for trading operations                         |
//+------------------------------------------------------------------+
class CTradeUtils
   {
public:
    // Calculate appropriate lot size based on risk percentage
    static double    CalculateLotSize(double riskPercentage, double stopLossPoints, double accountBase)
       {
        double tickValue = MarketInfo(Symbol(), MODE_TICKVALUE);
        double riskAmount = accountBase * riskPercentage / 100.0;
        double calculatedLotSize = riskAmount / (stopLossPoints * tickValue);
        double minLot = MarketInfo(Symbol(), MODE_MINLOT);
        double maxLot = MarketInfo(Symbol(), MODE_MAXLOT);
        double lotStep = MarketInfo(Symbol(), MODE_LOTSTEP);
        // Normalize lot size to broker's requirements
        calculatedLotSize = MathFloor(calculatedLotSize / lotStep) * lotStep;
        // Ensure lot size is within allowed range
        calculatedLotSize = MathMax(minLot, MathMin(maxLot, calculatedLotSize));
        return NormalizeDouble(calculatedLotSize, 2);
       }

    // Calculate pip value
    static double    CalculatePipValue(double lotSize)
       {
        double tickSize = MarketInfo(Symbol(), MODE_TICKSIZE);
        double tickValue = MarketInfo(Symbol(), MODE_TICKVALUE);
        double point = MarketInfo(Symbol(), MODE_POINT);
        // For 5-digit brokers where 1 pip = 10 points
        double pipSize = (Digits == 3 || Digits == 5) ? point * 10 : point;
        return (tickValue / tickSize) * pipSize * lotSize;
       }

    // Check if market is open
    static bool      IsMarketOpen()
       {
        return (bool)MarketInfo(Symbol(), MODE_TRADEALLOWED);
       }

    // Calculate distance in points between two prices
    static int       CalculatePointDistance(double price1, double price2)
       {
        return (int)MathRound(MathAbs(price1 - price2) / Point);
       }

    // Format price with proper digits
    static string    FormatPrice(double price)
       {
        return DoubleToString(price, Digits);
       }

    // Check if it's time to trade (avoid trading during high-impact news or at rollover)
    static bool      IsSafeToTrade()
       {
        datetime serverTime = TimeCurrent();
        int hour = TimeHour(serverTime);
        int minute = TimeMinute(serverTime);
        // Avoid trading at typical rollover time (00:00-00:05 server time)
        if(hour == 0 && minute < 5)
            return false;
        // Add more conditions as needed
        return true;
       }

    // Get broker server time
    static string    GetServerTime()
       {
        return TimeToString(TimeCurrent(), TIME_DATE | TIME_MINUTES | TIME_SECONDS);
       }
   };

#endif
//+------------------------------------------------------------------+
