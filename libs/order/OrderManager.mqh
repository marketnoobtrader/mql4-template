//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#ifndef __ORDER_MANAGER_MQH__
#define __ORDER_MANAGER_MQH__

#include "OrderManagerConstants.mqh"

//+------------------------------------------------------------------+
//| Base Order Manager class                                         |
//+------------------------------------------------------------------+
class COrderManager
   {
protected:
    double           m_lotSize;     // Trading lot size
    int              m_slippagePoints; // Allowed slippage in points
    double           m_stopLoss;    // Stop loss in points
    double           m_takeProfit;  // Take profit in points

    // Internal variables
    int              m_ticket;             // Order ticket
    double           m_entryPrice;      // Entry price
    double           m_stopLossPrice;   // Stop loss price
    double           m_takeProfitPrice; // Take profit price
    bool             m_result;            // Operation result

public:
    // Constructor
                     COrderManager(double lotSize = DEFAULT_LOT_SIZE, int slippagePoints = DEFAULT_SLIPPAGE,
                  double stopLoss = DEFAULT_STOP_LOSS, double takeProfit = DEFAULT_TAKE_PROFIT)
       {
        m_lotSize = lotSize;
        m_slippagePoints = slippagePoints;
        m_stopLoss = stopLoss;
        m_takeProfit = takeProfit;
       }

    // Destructor
                    ~COrderManager() {}

    //setters

    void             setLotSize(double lot)
       {
        m_lotSize = lot;
       }

    void             setStopLoss(double sl)
       {
        m_stopLoss = sl;
       }

    void             setTakeProfit(double tp)
       {
        m_takeProfit = tp;
       }

    void             setSlippagePoints(int value)
       {
        m_slippagePoints = value;
       }

    // Static utility methods
    // Normalize decimal places according to symbol digits
    static double    NormalizePrice(double price)
       {
        return NormalizeDouble(price, Digits);
       }

    // Calculate spread in points
    static double    CalculateSpread()
       {
        return NormalizeDouble(MarketInfo(Symbol(), MODE_SPREAD) * Point, Digits);
       }

    // Set expiration time for pending orders (next day)
    static datetime  GetOrderExpiration()
       {
        // return iTime(NULL, PERIOD_D1, 0) + 86400; // 24 hours
        return 0;
       }

    // Close a specific position by ticket
    static bool      ClosePosition(int ticket, int slippagePoints = DEFAULT_SLIPPAGE)
       {
        if(OrderSelect(ticket, SELECT_BY_TICKET))
           {
            if(!OrderCloseTime())
               {
                bool result = OrderClose(OrderTicket(), OrderLots(), OrderClosePrice(), slippagePoints, clrNONE);
                if(!result)
                   {
                    Print(ERROR_CLOSE, ticket, ": ", GetLastError());
                    return false;
                   }
                return true;
               }
           }
        return false;
       }

    // Check if a position of specific type is open
    static int       GetTypeOpenTicket(int orderType)
       {
        for(int i = 0; i < OrdersTotal(); ++i)
           {
            if(OrderSelect(i, SELECT_BY_POS))
               {
                if(!OrderCloseTime() && OrderType() == orderType)
                   {
                    return OrderTicket();
                   }
               }
           }
        return 0;
       }

    // Check if a specific position is open
    static bool      IsPositionOpen(int ticket)
       {
        if(OrderSelect(ticket, SELECT_BY_TICKET))
           {
            if((OrderType() == OP_BUY || OrderType() == OP_SELL) && !OrderCloseTime())
               {
                return true;
               }
           }
        return false;
       }

    // Check if a specific pending order exists
    static bool      IsPendingOrder(int ticket)
       {
        if(OrderSelect(ticket, SELECT_BY_TICKET))
           {
            if(!OrderCloseTime() && OrderType() > OP_SELL)  // OP_BUYLIMIT, OP_SELLLIMIT, OP_BUYSTOP, OP_SELLSTOP
               {
                return true;
               }
           }
        return false;
       }

    // Delete a specific pending order
    static bool      DeletePendingOrder(int ticket)
       {
        if(ticket <= 0)
            return false;
        if(OrderSelect(ticket, SELECT_BY_TICKET))
           {
            if(OrderType() > OP_SELL && !OrderCloseTime())
               {
                bool result = OrderDelete(OrderTicket());
                if(!result)
                   {
                    Print(ERROR_DELETE, ticket, ": ", GetLastError());
                    return false;
                   }
                return true;
               }
           }
        return false;
       }

    // Delete all pending orders
    static void      DeleteAllPendingOrders()
       {
        for(int i = 0; i < OrdersTotal(); ++i)
           {
            if(OrderSelect(i, SELECT_BY_POS))
               {
                if(OrderType() > OP_SELL && !OrderCloseTime())
                   {
                    bool result = OrderDelete(OrderTicket());
                    if(!result)
                       {
                        Print(ERROR_DELETE, OrderTicket(), ": ", GetLastError());
                       }
                   }
               }
           }
       }

    // Close all positions
    static void      CloseAllPositions(int slippagePoints = DEFAULT_SLIPPAGE)
       {
        for(int i = 0; i < OrdersTotal(); ++i)
           {
            if(OrderSelect(i, SELECT_BY_POS))
               {
                if((OrderType() == OP_BUY || OrderType() == OP_SELL) && !OrderCloseTime())
                   {
                    bool result = OrderClose(OrderTicket(), OrderLots(), OrderClosePrice(), slippagePoints, clrNONE);
                    if(!result)
                       {
                        Print(ERROR_CLOSE, OrderTicket(), ": ", GetLastError());
                       }
                   }
               }
           }
       }

    // Check if a closed position has profit
    static bool      IsPositionProfitable(int ticket)
       {
        if(OrderSelect(ticket, SELECT_BY_TICKET))
           {
            if(OrderCloseTime() && OrderProfit() > 0)
               {
                return true;
               }
           }
        return false;
       }

    // Check if a opened position has profit
    static bool      IsOpenedPositionProfitable(int ticket)
       {
        if(OrderSelect(ticket, SELECT_BY_TICKET))
           {
            if(!OrderCloseTime() && OrderProfit() > 0)
               {
                return true;
               }
           }
        return false;
       }
   };

#endif
//+------------------------------------------------------------------+
