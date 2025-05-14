//+------------------------------------------------------------------+
//|                                          Example_TradeHistory.mq4 |
//|                           Copyright 2025, MetaQuotes Software Corp. |
//|                                     https://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, MetaQuotes Software Corp."
#property link "https://www.metaquotes.net"
#property version "1.00"
#property strict

#include "trade-history.mqh"

// Create global instance of the TradeHistory class
TradeHistory history(10); // Track last 10 orders

//+------------------------------------------------------------------+
//| Helper function to convert order type to string                  |
//+------------------------------------------------------------------+
string OrderTypeToString(int type)
   {
    switch(type)
       {
        case OP_BUY:
            return "Buy";
        case OP_SELL:
            return "Sell";
        case OP_BUYLIMIT:
            return "Buy Limit";
        case OP_SELLLIMIT:
            return "Sell Limit";
        case OP_BUYSTOP:
            return "Buy Stop";
        case OP_SELLSTOP:
            return "Sell Stop";
        default:
            return "Unknown";
       }
   }

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
   {
    history.Update();
    return (INIT_SUCCEEDED);
   }

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
   {
// Nothing to clean up
   }

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
   {
    static datetime lastUpdateTime = 0;
    if(TimeCurrent() - lastUpdateTime >= 60)
       {
        OnTradeExecuted();
        lastUpdateTime = TimeCurrent();
       }
    if(history.GetTotalNetProfit() > 0)
       {
        Comment("Overall, we're profitable: " + DoubleToString(history.GetTotalNetProfit(), 2));
       }
    else
       {
        Comment("We're down: " + DoubleToString(history.GetTotalNetProfit(), 2));
       }
   }

//+------------------------------------------------------------------+
//| Function to demonstrate how to access individual order details   |
//+------------------------------------------------------------------+
void AnalyzeSpecificOrder(int index)
   {
    SPositionInfo histInfo;
    if(history.GetOrderInfo(index, histInfo))
       {
        Print("======== Order Info (Index #", index, ") ========");
        Print("Ticket: ", histInfo.ticket);
        Print("Type: ", OrderTypeToString(histInfo.type));
        Print("Symbol: ", histInfo.symbol);
        Print("Lot Size: ", DoubleToString(histInfo.lot, 2));
        Print("Open Price: ", DoubleToString(histInfo.openPrice, Digits));
        Print("Close Price: ", DoubleToString(histInfo.closePrice, Digits));
        Print("Price Distance: ", DoubleToString(histInfo.priceDistance, Digits));
        Print("Stop Loss (points): ", DoubleToString(histInfo.stoplossPoint, 1));
        Print("Take Profit (points): ", DoubleToString(histInfo.takeProfitPoint, 1));
        Print("Stop Loss Price: ", DoubleToString(histInfo.stoplossPrice, Digits));
        Print("Take Profit Price: ", DoubleToString(histInfo.takeProfitPrice, Digits));
        Print("Open Time: ", TimeToString(histInfo.openTime, TIME_DATE | TIME_MINUTES));
        Print("Close Time: ", TimeToString(histInfo.closeTime, TIME_DATE | TIME_MINUTES));
        Print("Last Modified: ", TimeToString(histInfo.lastModify, TIME_DATE | TIME_MINUTES));
        Print("Profit: ", DoubleToString(histInfo.profit, 2));
        int durationSeconds = (int)(histInfo.closeTime - histInfo.openTime);
        Print("Trade Duration: ", durationSeconds, " seconds (", durationSeconds / 60, " minutes)");
       }
    else
       {
        Print("Failed to get order information for index ", index);
       }
   }

//+------------------------------------------------------------------+
//| Custom function that can be called after a trade is executed     |
//+------------------------------------------------------------------+
void OnTradeExecuted()
   {
    if(history.Update())
       {
        Print("Trade history updated after new trade");
        history.PrintLastOrders();
        AnalyzeSpecificOrder(0);
       }
   }

//+------------------------------------------------------------------+
