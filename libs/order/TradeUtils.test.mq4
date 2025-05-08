//+------------------------------------------------------------------+
//|                                                TestCaller.mq4    |
//|               Demonstrates all method calls from CTradeUtils     |
//+------------------------------------------------------------------+
#property strict

#include "TradeUtils.mqh"

input double RiskPercent = 1.0;   // Risk percentage per trade
input int StopLossPoints = 300;   // Stop loss in points
input double TestLotSize = 0.1;   // Lot size for pip value test
input double TestPrice1 = 1.1050; // Sample price 1
input double TestPrice2 = 1.1010; // Sample price 2

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
   {
    Print("=== Calling All CTradeUtils Methods ===");
// 1. CalculateLotSize
    double lotSize = CTradeUtils::CalculateLotSize(RiskPercent, StopLossPoints, AccountBalance());
    Print("Calculated Lot Size: ", DoubleToString(lotSize, 2));
// 2. CalculatePipValue
    double pipValue = CTradeUtils::CalculatePipValue(TestLotSize);
    Print("Calculated Pip Value for ", TestLotSize, " lots: ", DoubleToString(pipValue, 2));
// 3. IsMarketOpen
    bool marketOpen = CTradeUtils::IsMarketOpen();
    Print("Is Market Open? ", marketOpen ? "Yes" : "No");
// 4. CalculatePointDistance
    int pointDist = CTradeUtils::CalculatePointDistance(TestPrice1, TestPrice2);
    Print("Point Distance between ", TestPrice1, " and ", TestPrice2, ": ", pointDist, " points");
// 5. FormatPrice
    string formattedPrice = CTradeUtils::FormatPrice(TestPrice1);
    Print("Formatted Price: ", formattedPrice);
// 6. IsSafeToTrade
    bool safeToTrade = CTradeUtils::IsSafeToTrade();
    Print("Is it safe to trade now? ", safeToTrade ? "Yes" : "No");
// 7. GetServerTime
    string serverTime = CTradeUtils::GetServerTime();
    Print("Server Time: ", serverTime);
    Print("=== Done ===");
    return (INIT_SUCCEEDED);
   }

//+------------------------------------------------------------------+
//| OnTick - not used                                                |
//+------------------------------------------------------------------+
void OnTick() {}
//+------------------------------------------------------------------+
