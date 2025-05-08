#ifndef __STRATEGY_ABSTRACT_MQH__
#define __STRATEGY_ABSTRACT_MQH__

#include "../order/TradingSystem.mqh"

class ITradeStrategy
{
protected:
   CTradingSystem *m_orderManager;

public:
   ITradeStrategy(CTradingSystem *orderManager) : m_orderManager(orderManager) {}

   virtual void updateData() = 0;
   virtual bool shouldBuy() = 0;
   virtual bool shouldSell() = 0;
   virtual int setBuy() = 0;
   virtual int setSell() = 0;
};

#endif
