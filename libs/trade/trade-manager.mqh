//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+

#ifndef __TRADE_MANAGER_MQH__
#define __TRADE_MANAGER_MQH__

#include "../strategy/strategy-abstract.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class BotController
{
private:
    ITradeStrategy *m_strategy;

public:
    BotController(ITradeStrategy *strat)
    {
        m_strategy = strat;
    }

    void OnNewTick()
    {
        m_strategy.updateData();
        if (m_strategy.shouldBuy())
            m_strategy.setBuy();
        else if (m_strategy.shouldSell())
            m_strategy.setSell();
    }
};

#endif
//+------------------------------------------------------------------+
