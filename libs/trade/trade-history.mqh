//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#ifndef __TRADE_HISTORY_MQH__
#define __TRADE_HISTORY_MQH__

struct HistoryOrderInfo
{
   int ticket;
   datetime openTime;
   datetime closeTime;
   int type;
   double lots;
   string symbol;
   double openPrice;
   double closePrice;
   double profit;
};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class TradeHistory
{
private:
   int m_historyCount;
   int m_totalBuyOrders;
   int m_totalSellOrders;
   double m_totalNetProfit;  // Total net profit
   double m_totalBuyProfit;  // Total profit from buy orders
   double m_totalSellProfit; // Total profit from sell orders

   HistoryOrderInfo m_orders[];

public:
   TradeHistory(int historyCount = 5)
   {
      SetHistoryCount(historyCount);
   }

   void SetHistoryCount(int count)
   {
      if (count <= 0)
         count = 5; // Default to 5 if invalid number provided
      m_historyCount = count;
      ArrayResize(m_orders, m_historyCount);
   }

   bool Update()
   {
      m_totalNetProfit = 0;
      m_totalBuyOrders = 0;
      m_totalSellOrders = 0;
      m_totalBuyProfit = 0;
      m_totalSellProfit = 0;
      // In MQL4, we don't need to refresh history explicitly like in MQL5
      // Get total number of historical orders
      int totalOrders = OrdersHistoryTotal();
      if (totalOrders == 0)
         return true; // No history - nothing to do
      int ordersFound = 0;
      for (int i = totalOrders - 1; i >= 0 && ordersFound < m_historyCount; i--)
      {
         if (!OrderSelect(i, SELECT_BY_POS, MODE_HISTORY))
            continue;
         if (OrderSymbol() != Symbol())
            continue;
         ProcessOrder();
         m_orders[ordersFound].ticket = OrderTicket();
         m_orders[ordersFound].openTime = OrderOpenTime();
         m_orders[ordersFound].closeTime = OrderCloseTime();
         m_orders[ordersFound].type = OrderType();
         m_orders[ordersFound].lots = OrderLots();
         m_orders[ordersFound].symbol = OrderSymbol();
         m_orders[ordersFound].openPrice = OrderOpenPrice();
         m_orders[ordersFound].closePrice = OrderClosePrice();
         m_orders[ordersFound].profit = OrderProfit(); // + OrderSwap() + OrderCommission();
         ordersFound++;
      }
      m_totalNetProfit = NormalizeDouble(m_totalNetProfit, Digits);
      m_totalBuyProfit = NormalizeDouble(m_totalBuyProfit, Digits);
      m_totalSellProfit = NormalizeDouble(m_totalSellProfit, Digits);
      return ordersFound > 0 ? true : false;
   }

   double GetTotalNetProfit() const
   {
      return m_totalNetProfit;
   }

   int GetTotalBuyOrders() const
   {
      return m_totalBuyOrders;
   }

   int GetTotalSellOrders() const
   {
      return m_totalSellOrders;
   }

   double GetTotalBuyProfit() const
   {
      return m_totalBuyProfit;
   }

   double GetTotalSellProfit() const
   {
      return m_totalSellProfit;
   }

   bool GetOrderInfo(int index, HistoryOrderInfo &target)
   {
      if (index < 0 || index >= m_historyCount)
         return false;
      target = m_orders[index];
      return true;
   }

   void PrintLastOrders()
   {
      Print("");
      Print("");
      Print("");
      Print("");
      Print("");
      Print("===== Last ", m_historyCount, " Orders =====");
      for (int i = 0; i < m_historyCount; i++)
      {
         if (m_orders[i].ticket == 0)
            continue;
         string orderType = (m_orders[i].type == OP_BUY) ? "BUY" : (m_orders[i].type == OP_SELL) ? "SELL"
                                                                                                 : IntegerToString(m_orders[i].type);
         Print("Order #", i, ": Ticket=", m_orders[i].ticket,
               ", Type=", orderType,
               ", Open=", TimeToString(m_orders[i].openTime),
               ", Close=", TimeToString(m_orders[i].closeTime),
               ", Profit=", m_orders[i].profit);
      }
      Print("Total Buy Orders: ", m_totalBuyOrders, ", Profit: ", m_totalBuyProfit);
      Print("Total Sell Orders: ", m_totalSellOrders, ", Profit: ", m_totalSellProfit);
      Print("Total Net Profit: ", m_totalNetProfit);
   }

private:
   void ProcessOrder()
   {
      double profit = OrderProfit(); // + OrderSwap() + OrderCommission();
      m_totalNetProfit += profit;
      if (OrderType() == OP_BUY)
      {
         m_totalBuyOrders++;
         m_totalBuyProfit += profit;
      }
      else if (OrderType() == OP_SELL)
      {
         m_totalSellOrders++;
         m_totalSellProfit += profit;
      }
   }
};

#endif
//+------------------------------------------------------------------+
