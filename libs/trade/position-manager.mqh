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
            pos.takeProfitPoint = MathAbs(pos.openPrice - pos.takeProfitPrice);
            if(pos.type == OP_BUY || pos.type == OP_BUYLIMIT || pos.type == OP_BUYSTOP)
               {
                pos.stoplossPoint = pos.openPrice - pos.stoplossPrice;
               }
            else
               {
                pos.stoplossPoint = pos.stoplossPrice - pos.openPrice;
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
