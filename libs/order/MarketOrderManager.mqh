//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#ifndef __MARKET_ORDER_MANAGER_MQH__
#define __MARKET_ORDER_MANAGER_MQH__

#include "OrderManagerConstants.mqh"
#include "OrderManager.mqh"

//+------------------------------------------------------------------+
//| Market Order Manager class - for immediate execution orders      |
//+------------------------------------------------------------------+
class CMarketOrderManager : public COrderManager
   {
public:
    // Constructor
                     CMarketOrderManager(double lotSize = DEFAULT_LOT_SIZE, int slippagePoints = DEFAULT_SLIPPAGE,
                        double stopLoss = DEFAULT_STOP_LOSS, double takeProfit = DEFAULT_TAKE_PROFIT)
        :            COrderManager(lotSize, slippagePoints, stopLoss, takeProfit) {}

    // Static methods for market orders
    // Place a Buy market order
    static int       PlaceBuyOrder(double lotSize, int slippagePoints, double stopLoss, double takeProfit, string comment = COMMENT_BUY)
       {
        double entryPrice = Ask;
        double stopLossPrice = NormalizePrice(entryPrice - stopLoss * Point);
        double takeProfitPrice = NormalizePrice(entryPrice + takeProfit * Point);
        int ticket = OrderSend(
                         Symbol(),
                         OP_BUY,
                         lotSize,
                         entryPrice,
                         slippagePoints,
                         stopLossPrice,
                         takeProfitPrice,
                         comment,
                         0,
                         0,
                         COLOR_BUY);
        if(ticket < 0)
           {
            Print(ERROR_BUY, GetLastError());
            return -1;
           }
        return ticket;
       }

    // Instance method for buy orders (uses instance variables)
    int              PlaceBuy(string comment = COMMENT_BUY)
       {
        m_entryPrice = Ask;
        m_stopLossPrice = NormalizePrice(m_entryPrice - m_stopLoss * Point);
        m_takeProfitPrice = NormalizePrice(m_entryPrice + m_takeProfit * Point);
        m_ticket = OrderSend(
                       Symbol(),
                       OP_BUY,
                       m_lotSize,
                       m_entryPrice,
                       m_slippagePoints,
                       m_stopLossPrice,
                       m_takeProfitPrice,
                       comment,
                       0,
                       0,
                       COLOR_BUY);
        if(m_ticket < 0)
           {
            Print(ERROR_BUY, GetLastError());
            return -1;
           }
        return m_ticket;
       }

    // Static method for sell orders
    static int       PlaceSellOrder(double lotSize, int slippagePoints, double stopLoss, double takeProfit, string comment = COMMENT_SELL)
       {
        double entryPrice = Bid;
        double stopLossPrice = NormalizePrice(entryPrice + stopLoss * Point);
        double takeProfitPrice = NormalizePrice(entryPrice - takeProfit * Point);
        int ticket = OrderSend(
                         Symbol(),
                         OP_SELL,
                         lotSize,
                         entryPrice,
                         slippagePoints,
                         stopLossPrice,
                         takeProfitPrice,
                         comment,
                         0,
                         0,
                         COLOR_SELL);
        if(ticket < 0)
           {
            Print(ERROR_SELL, GetLastError());
            return -1;
           }
        return ticket;
       }

    // Instance method for sell orders (uses instance variables)
    int              PlaceSell(string comment = COMMENT_SELL)
       {
        m_entryPrice = Bid;
        m_stopLossPrice = NormalizePrice(m_entryPrice + m_stopLoss * Point);
        m_takeProfitPrice = NormalizePrice(m_entryPrice - m_takeProfit * Point);
        m_ticket = OrderSend(
                       Symbol(),
                       OP_SELL,
                       m_lotSize,
                       m_entryPrice,
                       m_slippagePoints,
                       m_stopLossPrice,
                       m_takeProfitPrice,
                       comment,
                       0,
                       0,
                       COLOR_SELL);
        if(m_ticket < 0)
           {
            Print(ERROR_SELL, GetLastError());
            return -1;
           }
        return m_ticket;
       }
   };

#endif
//+------------------------------------------------------------------+
