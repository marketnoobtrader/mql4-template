//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#include "types.trade.mqh"
#include "position-manager.mqh" // Assuming your class is saved here

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
input double InpBreakEvenProfit = 1; // Profit points for break-even (0 = disabled)
input double InpBreakEvenOffset = 0;  // Break-even offset in points (0 = exact entry)
input bool InpPrintPositions = true;   // Print position details on each tick

CPositionManager positionManager;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void PrintAllPositions(int total)
   {
    SPositionInfo pos;
    for(int i = 0; i < total; i++)
       {
        if(positionManager.GetPositionByIndex(i, pos))
           {
            PrintFormat("#[%d] Ticket=%d| Symbol=%s| Type=%s| Lot=%.2f| OpenPrice=%.5f| ClosePrice=%.5f| Profit=%.2f| SL Points=%.2f| TP Points=%.2f| SL Price=%.5f| TP Price=%.5f| OpenTime=%s| CloseTime=%s| LastModify=%s",
                        i,
                        pos.ticket,
                        pos.symbol,
                        OrderTypeToString(pos.type),
                        pos.lot,
                        pos.openPrice,
                        pos.closePrice,
                        pos.profit,
                        pos.stoplossPoint,
                        pos.takeProfitPoint,
                        pos.stoplossPrice,
                        pos.takeProfitPrice,
                        TimeToString(pos.openTime, TIME_DATE | TIME_SECONDS),
                        TimeToString(pos.closeTime, TIME_DATE | TIME_SECONDS),
                        TimeToString(pos.lastModify, TIME_DATE | TIME_SECONDS));
           }
       }
   }

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
   {
    Print("Initializing Position Manager...");
    positionManager.UpdateFromMarket();
    int total = positionManager.Total();
    if(InpBreakEvenProfit > 0)
       {
        positionManager.SetBreakEvenAll(InpBreakEvenProfit, InpBreakEvenOffset);
       }
    if(InpPrintPositions)
       {
        Print("Total positions tracked: ", total);
        PrintAllPositions(total);
       }
    return INIT_SUCCEEDED;
   }

//+------------------------------------------------------------------+
//| Helper function to convert order type to string                  |
//+------------------------------------------------------------------+
string OrderTypeToString(int type)
   {
    switch(type)
       {
        case OP_BUY:
            return "Buy";
        case OP_SELL:
            return "Sell";
        case OP_BUYLIMIT:
            return "Buy Limit";
        case OP_SELLLIMIT:
            return "Sell Limit";
        case OP_BUYSTOP:
            return "Buy Stop";
        case OP_SELLSTOP:
            return "Sell Stop";
        default:
            return "Unknown";
       }
   }

//+------------------------------------------------------------------+
