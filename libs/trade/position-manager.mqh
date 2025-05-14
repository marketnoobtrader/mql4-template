//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+

#include "types.trade.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CPositionManager
   {
private:
    SPositionInfo    m_positions[];
    int              m_total;

    void             ResizeArray(int newSize, int reserveSize);

public:
                     CPositionManager();
                    ~CPositionManager();

    // Core methods
    void             AddPosition(const SPositionInfo &position);
    bool             UpdatePosition(const SPositionInfo &position);
    bool             RemovePosition(int ticket);
    void             ClearAll();

    // Getters
    int              Total() const { return m_total; }
    bool             GetPosition(int ticket, SPositionInfo &position) const;
    bool             GetPositionByIndex(int index, SPositionInfo &position) const;

    // Search methods
    int              FindPositionIndex(int ticket) const;
    bool             PositionExists(int ticket) const;

    // Utility methods
    void             UpdateFromMarket();
    double           GetTotalProfit() const;
    bool             CPositionManager::isBuyTypeOrder(SPositionInfo &target) const;

    // Risk Management
    static bool      CPositionManager::SetBreakEven(SPositionInfo &position, double minProfitPoints, double offsetPoints);
    void             SetBreakEvenAll(double minProfitPoints, double offsetPoints = 0);
   };

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CPositionManager::CPositionManager()
   {
    m_total = 0;
   }

//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CPositionManager::~CPositionManager()
   {
    ClearAll();
   }

//+------------------------------------------------------------------+
//| Resize internal array as needed                                  |
//+------------------------------------------------------------------+
void CPositionManager::ResizeArray(int newSize, int reserveSize = NULL)
   {
    if(reserveSize == NULL)
        reserveSize = newSize;
    ArrayResize(m_positions, newSize, reserveSize);
   }

//+------------------------------------------------------------------+
//| Add new position to the manager                                  |
//+------------------------------------------------------------------+
void CPositionManager::AddPosition(const SPositionInfo &position)
   {
    const int index = FindPositionIndex(position.ticket);
    if(index == -1)
       {
        ResizeArray(m_total + 1);
        m_positions[m_total] = position;
        m_total++;
       }
    else
       {
        m_positions[index] = position;
       }
   }

//+------------------------------------------------------------------+
//| Update existing position                                         |
//+------------------------------------------------------------------+
bool CPositionManager::UpdatePosition(const SPositionInfo &position)
   {
    int index = FindPositionIndex(position.ticket);
    if(index == -1)
        return false;
    m_positions[index] = position;
    return true;
   }

//+------------------------------------------------------------------+
//| Remove position by ticket number                                 |
//+------------------------------------------------------------------+
bool CPositionManager::RemovePosition(int ticket)
   {
    int index = FindPositionIndex(ticket);
    if(index == -1)
        return false;
// Shift all elements after the found index
    for(int i = index; i < m_total - 1; i++)
        m_positions[i] = m_positions[i + 1];
    ResizeArray(m_total - 1);
    m_total--;
    return true;
   }

//+------------------------------------------------------------------+
//| Clear all positions                                              |
//+------------------------------------------------------------------+
void CPositionManager::ClearAll()
   {
    m_total = 0;
    ResizeArray(0, 0);
   }

//+------------------------------------------------------------------+
//| Get position by ticket number                                   |
//+------------------------------------------------------------------+
bool CPositionManager::GetPosition(int ticket, SPositionInfo &position) const
   {
    int index = FindPositionIndex(ticket);
    if(index == -1)
        return false;
    position = m_positions[index];
    return true;
   }

//+------------------------------------------------------------------+
//| Get position by array index                                      |
//+------------------------------------------------------------------+
bool CPositionManager::GetPositionByIndex(int index, SPositionInfo &position) const
   {
    if(index < 0 || index >= m_total)
        return false;
    position = m_positions[index];
    return true;
   }

//+------------------------------------------------------------------+
//| Find position index by ticket number                             |
//+------------------------------------------------------------------+
int CPositionManager::FindPositionIndex(int ticket) const
   {
    for(int i = 0; i < m_total; i++)
        if(m_positions[i].ticket == ticket)
            return i;
    return -1;
   }

//+------------------------------------------------------------------+
//| Check if position exists                                        |
//+------------------------------------------------------------------+
bool CPositionManager::PositionExists(int ticket) const
   {
    return FindPositionIndex(ticket) != -1;
   }

//+------------------------------------------------------------------+
//| Update positions from market                                     |
//+------------------------------------------------------------------+
void CPositionManager::UpdateFromMarket()
   {
    SPositionInfo pos;
// Load open positions
    for(int i = 0; i < OrdersTotal(); i++)
       {
        if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
           {
            pos.ticket = OrderTicket();
            pos.lot = OrderLots();
            pos.type = OrderType();
            pos.symbol = OrderSymbol();
            pos.openPrice = OrderOpenPrice();
            pos.closePrice = OrderClosePrice();
            pos.profit = OrderProfit(); // + OrderSwap() + OrderCommission();
            pos.stoplossPrice = OrderStopLoss();
            pos.takeProfitPrice = OrderTakeProfit();
            pos.openTime = OrderOpenTime();
            pos.closeTime = OrderCloseTime();
            pos.lastModify = Time[0];
            if(isBuyTypeOrder(pos))
               {
                pos.priceDistance = Bid - pos.openPrice;
               }
            else
               {
                pos.priceDistance = pos.openPrice - Ask;
               }
            pos.takeProfitPoint = pos.takeProfitPrice == 0 ? 0 : MathAbs(pos.openPrice - pos.takeProfitPrice);
            if(pos.stoplossPrice == 0)
               {
                pos.stoplossPoint = 0;
               }
            else
               {
                if(isBuyTypeOrder(pos))
                   {
                    pos.stoplossPoint = pos.openPrice - pos.stoplossPrice;
                   }
                else
                   {
                    pos.stoplossPoint = pos.stoplossPrice - pos.openPrice;
                   }
               }
            AddPosition(pos);
           }
       }
   }

//+------------------------------------------------------------------+
//| Calculate total profit of all positions                          |
//+------------------------------------------------------------------+
double CPositionManager::GetTotalProfit() const
   {
    double total = 0;
    for(int i = 0; i < m_total; i++)
        total += m_positions[i].profit;
    return total;
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CPositionManager::isBuyTypeOrder(SPositionInfo &target) const
   {
    return target.type == OP_BUY || target.type == OP_BUYLIMIT || target.type == OP_BUYSTOP;
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static bool CPositionManager::SetBreakEven(SPositionInfo &position, double minProfitPoints = 0, double offsetPoints = 0)
   {
// Get market data
// double point = MarketInfo(position.symbol, MODE_POINT);
// int digits = (int)MarketInfo(position.symbol, MODE_DIGITS);
// double bid = MarketInfo(position.symbol, MODE_BID);
// double ask = MarketInfo(position.symbol, MODE_ASK);
    minProfitPoints *= _Point;
    offsetPoints *= _Point;
    if(
        position.type != OP_BUY &&
        position.type != OP_SELL)
        return false;
    if(position.closeTime != 0)
        return false;
    if(position.priceDistance < minProfitPoints)
        return false;
    int errorCode;
    double newStopLoss;
    const int ticket = position.ticket;
    if(position.type == OP_BUY)
        newStopLoss = position.openPrice + offsetPoints;
    else
        if(position.type == OP_SELL)
            newStopLoss = position.openPrice - offsetPoints;
// Update the stop loss in the market
    const bool isOrderSelected = OrderSelect(ticket, SELECT_BY_TICKET);
    if(!isOrderSelected)
       {
        errorCode = GetLastError();
        Print("Ticket: ", ticket, "| Can't select the order! Error code: ", errorCode);
        return false;
       }
    const bool isOrderModified = OrderModify(ticket, position.openPrice,
                                 NormalizeDouble(newStopLoss, Digits),
                                 position.takeProfitPrice,
                                 0,
                                 clrBlue);
    if(!isOrderModified)
       {
        errorCode = GetLastError();
        Print("Ticket: ", ticket, "| Can't modify the order! Error code: ", errorCode);
        Print("Ticket: ", ticket, "| newStopLoss: ", newStopLoss);
        return false;
       }
// Update our position record
    position.stoplossPrice = newStopLoss;
    if(position.type == OP_BUY)
        position.stoplossPoint = position.openPrice - position.stoplossPrice;
    else
        position.stoplossPoint = position.stoplossPrice - position.openPrice;
    position.lastModify = Time[0];
    return true;
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CPositionManager::SetBreakEvenAll(double minProfitPoints = 0, double offsetPoints = 0)
   {
    for(int i = 0; i < m_total; i++)
       {
        SetBreakEven(m_positions[i], minProfitPoints, offsetPoints);
       }
   }

//+------------------------------------------------------------------+
