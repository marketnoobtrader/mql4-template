//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#ifndef __TRADING_SYSTEM_MQH__
#define __TRADING_SYSTEM_MQH__

#include "OrderManagerConstants.mqh"
#include "MarketOrderManager.mqh"
#include "PendingOrderManager.mqh"

//+------------------------------------------------------------------+
//| Main trading class that uses both order managers                 |
//+------------------------------------------------------------------+
class CTradingSystem
{
private:
   CMarketOrderManager *m_marketOrderManager;
   CPendingOrderManager *m_pendingOrderManager;

public:
   // Constructor
   CTradingSystem(double lotSize = DEFAULT_LOT_SIZE, int slippagePoints = DEFAULT_SLIPPAGE,
                  double stopLoss = DEFAULT_STOP_LOSS, double takeProfit = DEFAULT_TAKE_PROFIT)
   {
      m_marketOrderManager = new CMarketOrderManager(lotSize, slippagePoints, stopLoss, takeProfit);
      m_pendingOrderManager = new CPendingOrderManager(lotSize, slippagePoints, stopLoss, takeProfit);
   }

   // Destructor
   ~CTradingSystem()
   {
      if (m_marketOrderManager != NULL)
         delete m_marketOrderManager;
      if (m_pendingOrderManager != NULL)
         delete m_pendingOrderManager;
   }

   void setLotSize(double lot)
   {
      GetMarketOrderManager().setLotSize(lot);
      GetPendingOrderManager().setLotSize(lot);
   }

   // Getters for the order managers
   CMarketOrderManager *GetMarketOrderManager() { return m_marketOrderManager; }
   CPendingOrderManager *GetPendingOrderManager() { return m_pendingOrderManager; }

   // Close all orders (both market and pending)
   void CloseAllOrders(int slippagePoints = DEFAULT_SLIPPAGE)
   {
      COrderManager::CloseAllPositions(slippagePoints);
      COrderManager::DeleteAllPendingOrders();
   }

   // Static methods for trading system operations
   static void CloseAllMarketAndPendingOrders(int slippagePoints = DEFAULT_SLIPPAGE)
   {
      COrderManager::CloseAllPositions(slippagePoints);
      COrderManager::DeleteAllPendingOrders();
   }
};

#endif
//+------------------------------------------------------------------+
