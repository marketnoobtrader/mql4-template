//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#ifndef __PENDING_ORDER_MANAGER_MQH__
#define __PENDING_ORDER_MANAGER_MQH__

#include "OrderManagerConstants.mqh"
#include "OrderManager.mqh"

//+------------------------------------------------------------------+
//| Pending Order Manager class - for pending orders                 |
//+------------------------------------------------------------------+
class CPendingOrderManager : public COrderManager
   {
private:
    // Magic numbers for different order types - static constants
    static const int BUYLIMIT_MAGIC ;
    static const int SELLLIMIT_MAGIC ;
    static const int BUYSTOP_MAGIC ;
    static const int SELLSTOP_MAGIC ;

public:
    // Constructor
                     CPendingOrderManager(double lotSize = DEFAULT_LOT_SIZE, int slippagePoints = DEFAULT_SLIPPAGE,
                         double stopLoss = DEFAULT_STOP_LOSS, double takeProfit = DEFAULT_TAKE_PROFIT)
        :            COrderManager(lotSize, slippagePoints, stopLoss, takeProfit) {}

    // Static methods for pending orders
    // Place a Buy Stop order
    static int       PlaceBuyStopOrder(double lotSize, int slippagePoints, double stopLoss,
                                 double takeProfit, double triggerPrice, string comment = COMMENT_BUY_STOP)
       {
        double spread = CalculateSpread();
        double entryPrice = NormalizePrice(triggerPrice + spread);
        double stopLossPrice = NormalizePrice(entryPrice - stopLoss * Point - spread);
        double takeProfitPrice = NormalizePrice(entryPrice + takeProfit * Point + spread);
        int ticket = OrderSend(
                         Symbol(),
                         OP_BUYSTOP,
                         lotSize,
                         entryPrice,
                         slippagePoints,
                         stopLossPrice,
                         takeProfitPrice,
                         comment,
                         BUYSTOP_MAGIC,
                         GetOrderExpiration(),
                         COLOR_BUY_STOP);
        if(ticket < 0)
           {
            Print(ERROR_BUY_STOP, GetLastError());
            return -1;
           }
        return ticket;
       }

    // Instance method for buy stop orders
    int              PlaceBuyStop(double triggerPrice, string comment = COMMENT_BUY_STOP)
       {
        double spread = CalculateSpread();
        m_entryPrice = NormalizePrice(triggerPrice + spread);
        m_stopLossPrice = NormalizePrice(m_entryPrice - m_stopLoss * Point - spread);
        m_takeProfitPrice = NormalizePrice(m_entryPrice + m_takeProfit * Point + spread);
        m_ticket = OrderSend(
                       Symbol(),
                       OP_BUYSTOP,
                       m_lotSize,
                       m_entryPrice,
                       m_slippagePoints,
                       m_stopLossPrice,
                       m_takeProfitPrice,
                       comment,
                       BUYSTOP_MAGIC,
                       GetOrderExpiration(),
                       COLOR_BUY_STOP);
        if(m_ticket < 0)
           {
            Print(ERROR_BUY_STOP, GetLastError());
            return -1;
           }
        return m_ticket;
       }

    // Static method for sell stop orders
    static int       PlaceSellStopOrder(double lotSize, int slippagePoints, double stopLoss,
                                  double takeProfit, double triggerPrice, string comment = COMMENT_SELL_STOP)
       {
        double spread = CalculateSpread();
        double entryPrice = NormalizePrice(triggerPrice - spread);
        double stopLossPrice = NormalizePrice(entryPrice + stopLoss * Point - spread);
        double takeProfitPrice = NormalizePrice(entryPrice - takeProfit * Point + spread);
        int ticket = OrderSend(
                         Symbol(),
                         OP_SELLSTOP,
                         lotSize,
                         entryPrice,
                         slippagePoints,
                         stopLossPrice,
                         takeProfitPrice,
                         comment,
                         SELLSTOP_MAGIC,
                         GetOrderExpiration(),
                         COLOR_SELL_STOP);
        if(ticket < 0)
           {
            Print(ERROR_SELL_STOP, GetLastError());
            return -1;
           }
        return ticket;
       }

    // Instance method for sell stop orders
    int              PlaceSellStop(double triggerPrice, string comment = COMMENT_SELL_STOP)
       {
        double spread = CalculateSpread();
        m_entryPrice = NormalizePrice(triggerPrice - spread);
        m_stopLossPrice = NormalizePrice(m_entryPrice + m_stopLoss * Point - spread);
        m_takeProfitPrice = NormalizePrice(m_entryPrice - m_takeProfit * Point + spread);
        m_ticket = OrderSend(
                       Symbol(),
                       OP_SELLSTOP,
                       m_lotSize,
                       m_entryPrice,
                       m_slippagePoints,
                       m_stopLossPrice,
                       m_takeProfitPrice,
                       comment,
                       SELLSTOP_MAGIC,
                       GetOrderExpiration(),
                       COLOR_SELL_STOP);
        if(m_ticket < 0)
           {
            Print(ERROR_SELL_STOP, GetLastError());
            return -1;
           }
        return m_ticket;
       }

    // Static method for buy limit orders
    static int       PlaceBuyLimitOrder(double lotSize, int slippagePoints, double stopLoss,
                                  double takeProfit, double triggerPrice, string comment = COMMENT_BUY_LIMIT)
       {
        double spread = CalculateSpread();
        double entryPrice = NormalizePrice(triggerPrice + spread);
        double stopLossPrice = NormalizePrice(entryPrice - stopLoss * Point - spread);
        double takeProfitPrice = NormalizePrice(entryPrice + takeProfit * Point + spread);
        int ticket = OrderSend(
                         Symbol(),
                         OP_BUYLIMIT,
                         lotSize,
                         entryPrice,
                         slippagePoints,
                         stopLossPrice,
                         takeProfitPrice,
                         comment,
                         BUYLIMIT_MAGIC,
                         GetOrderExpiration(),
                         COLOR_BUY_LIMIT);
        if(ticket < 0)
           {
            Print(ERROR_BUY_LIMIT, GetLastError());
            return -1;
           }
        return ticket;
       }

    // Instance method for buy limit orders
    int              PlaceBuyLimit(double triggerPrice, string comment = COMMENT_BUY_LIMIT)
       {
        double spread = CalculateSpread();
        m_entryPrice = NormalizePrice(triggerPrice + spread);
        m_stopLossPrice = NormalizePrice(m_entryPrice - m_stopLoss * Point - spread);
        m_takeProfitPrice = NormalizePrice(m_entryPrice + m_takeProfit * Point + spread);
        m_ticket = OrderSend(
                       Symbol(),
                       OP_BUYLIMIT,
                       m_lotSize,
                       m_entryPrice,
                       m_slippagePoints,
                       m_stopLossPrice,
                       m_takeProfitPrice,
                       comment,
                       BUYLIMIT_MAGIC,
                       GetOrderExpiration(),
                       COLOR_BUY_LIMIT);
        if(m_ticket < 0)
           {
            Print(ERROR_BUY_LIMIT, GetLastError());
            return -1;
           }
        return m_ticket;
       }

    // Static method for sell limit orders
    static int       PlaceSellLimitOrder(double lotSize, int slippagePoints, double stopLoss,
                                   double takeProfit, double triggerPrice, string comment = COMMENT_SELL_LIMIT)
       {
        double spread = CalculateSpread();
        double entryPrice = NormalizePrice(triggerPrice - spread);
        double stopLossPrice = NormalizePrice(entryPrice + stopLoss * Point - spread);
        double takeProfitPrice = NormalizePrice(entryPrice - takeProfit * Point + spread);
        int ticket = OrderSend(
                         Symbol(),
                         OP_SELLLIMIT,
                         lotSize,
                         entryPrice,
                         slippagePoints,
                         stopLossPrice,
                         takeProfitPrice,
                         comment,
                         SELLLIMIT_MAGIC,
                         GetOrderExpiration(),
                         COLOR_SELL_LIMIT);
        if(ticket < 0)
           {
            Print(ERROR_SELL_LIMIT, GetLastError());
            return -1;
           }
        return ticket;
       }

    // Instance method for sell limit orders
    int              PlaceSellLimit(double triggerPrice, string comment = COMMENT_SELL_LIMIT)
       {
        double spread = CalculateSpread();
        m_entryPrice = NormalizePrice(triggerPrice - spread);
        m_stopLossPrice = NormalizePrice(m_entryPrice + m_stopLoss * Point - spread);
        m_takeProfitPrice = NormalizePrice(m_entryPrice - m_takeProfit * Point + spread);
        m_ticket = OrderSend(
                       Symbol(),
                       OP_SELLLIMIT,
                       m_lotSize,
                       m_entryPrice,
                       m_slippagePoints,
                       m_stopLossPrice,
                       m_takeProfitPrice,
                       comment,
                       SELLLIMIT_MAGIC,
                       GetOrderExpiration(),
                       COLOR_SELL_LIMIT);
        if(m_ticket < 0)
           {
            Print(ERROR_SELL_LIMIT, GetLastError());
            return -1;
           }
        return m_ticket;
       }

    // Getters for magic numbers
    static int       GetBuyLimitMagic() { return BUYLIMIT_MAGIC; }
    static int       GetSellLimitMagic() { return SELLLIMIT_MAGIC; }
    static int       GetBuyStopMagic() { return BUYSTOP_MAGIC; }
    static int       GetSellStopMagic() { return SELLSTOP_MAGIC; }
   };

// Define static constants
const int CPendingOrderManager::BUYLIMIT_MAGIC = 1111;
const int CPendingOrderManager::SELLLIMIT_MAGIC = 2222;
const int CPendingOrderManager::BUYSTOP_MAGIC = 3333;
const int CPendingOrderManager::SELLSTOP_MAGIC = 4444;

#endif
//+------------------------------------------------------------------+
