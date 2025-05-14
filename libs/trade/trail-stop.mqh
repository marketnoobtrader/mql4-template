//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#ifndef __TRAIL_STOP_MQH__
#define __TRAIL_STOP_MQH__

#include "types.trade.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void _SetStopLoss(SPositionInfo &position, double slPrice, int expectedOrderType)
   {
    if(!OrderSelect(position.ticket, SELECT_BY_TICKET, MODE_TRADES))
        return;
    if(OrderType() != expectedOrderType || OrderSymbol() != Symbol())
        return;
    int ticket = OrderTicket();
    double normalizedSL = NormalizeDouble(slPrice, Digits);
    bool modified = OrderModify(ticket, OrderOpenPrice(), normalizedSL, OrderTakeProfit(), 0, clrRed);
    if(!modified)
       {
        Print("Order #", ticket, " - Error modifying SL: ", GetLastError());
       }
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetStopLossForBuyOrders(SPositionInfo &position, double slPrice)
   {
    _SetStopLoss(position, slPrice, OP_BUY);
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetStopLossForSellOrders(SPositionInfo &position, double slPrice)
   {
    _SetStopLoss(position, slPrice, OP_SELL);
   }


#endif
//+------------------------------------------------------------------+
