//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+

#include "strategy-abstract.mqh"
#include "../order/TradingSystem.mqh"
#include "../tools/logger.mqh"
#include "../inputs.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class MaCrossoverStrategy : public ITradeStrategy
   {
private:
    CLogger          *_logger;
    double           fastMA1, fastMA2;
    double           slowMA1, slowMA2;

public:
                     MaCrossoverStrategy(CTradingSystem *orderManager) : ITradeStrategy(orderManager)
       {
        _logger = CLogger::GetInstance();
       }

    void             updateData() override
       {
        fastMA1 = iMA(_Symbol, Timeframe, Fast_MA_Period, 0, Fast_MA_Method, Fast_MA_Applied, 1);
        fastMA2 = iMA(_Symbol, Timeframe, Fast_MA_Period, 0, Fast_MA_Method, Fast_MA_Applied, 2);
        slowMA1 = iMA(_Symbol, Timeframe, Slow_MA_Period, 0, Slow_MA_Method, Slow_MA_Applied, 1);
        slowMA2 = iMA(_Symbol, Timeframe, Slow_MA_Period, 0, Slow_MA_Method, Slow_MA_Applied, 2);
       }

    bool             shouldBuy() override
       {
        return (fastMA1 > slowMA1 && fastMA2 < slowMA2);
       }

    bool             shouldSell() override
       {
        return (fastMA1 < slowMA1 && fastMA2 > slowMA2);
       }

    int              setBuy() override
       {
        return m_orderManager.GetMarketOrderManager().PlaceBuy();
       }

    int              setSell() override
       {
        return m_orderManager.GetMarketOrderManager().PlaceSell();
       }
   };
//+------------------------------------------------------------------+
