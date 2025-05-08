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
    HistoryOrderInfo histInfo;
// Get details of the specific order
    if(history.GetOrderInfo(index, histInfo))
       {
        // Do something with the order information
        string orderType = (histInfo.type == OP_BUY) ? "BUY" : (histInfo.type == OP_SELL) ? "SELL"
                           : IntegerToString(histInfo.type);
        Print("Analyzing order #", index);
        Print("Type: ", orderType);
        Print("Ticket: ", histInfo.ticket);
        Print("Open Time: ", TimeToString(histInfo.openTime));
        Print("Close Time: ", TimeToString(histInfo.closeTime));
        Print("Symbol: ", histInfo.symbol);
        Print("Open Price: ", DoubleToString(histInfo.openPrice, Digits));
        Print("Close Price: ", DoubleToString(histInfo.closePrice, Digits));
        Print("Profit: ", DoubleToString(histInfo.profit, 2));
        // Example: Calculate trade duration
        int durationSeconds = (int)(histInfo.closeTime - histInfo.openTime);
        Print("Trade duration: ", durationSeconds, " seconds (", durationSeconds / 60, " minutes)");
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
        Print("=========================");
        AnalyzeSpecificOrder(0);
       }
   }

//+------------------------------------------------------------------+
