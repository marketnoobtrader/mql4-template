//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#ifndef __ORDER_MANAGER_CONSTANTS_MQH__
#define __ORDER_MANAGER_CONSTANTS_MQH__

// Default values for trading parameters
#define DEFAULT_LOT_SIZE 0.01
#define DEFAULT_SLIPPAGE 5
#define DEFAULT_STOP_LOSS 50.0
#define DEFAULT_TAKE_PROFIT 100.0

// Order comments
#define COMMENT_BUY "Buy order"
#define COMMENT_SELL "Sell order"
#define COMMENT_BUY_STOP "Buy Stop order"
#define COMMENT_SELL_STOP "Sell Stop order"
#define COMMENT_BUY_LIMIT "Buy Limit order"
#define COMMENT_SELL_LIMIT "Sell Limit order"

// Error codes and messages
#define ERROR_BUY "Buy order error: "
#define ERROR_SELL "Sell order error: "
#define ERROR_BUY_STOP "Buy Stop order error: "
#define ERROR_SELL_STOP "Sell Stop order error: "
#define ERROR_BUY_LIMIT "Buy Limit order error: "
#define ERROR_SELL_LIMIT "Sell Limit order error: "
#define ERROR_CLOSE "Error closing position #"
#define ERROR_DELETE "Error deleting pending order #"

// Colors for order visualization
#define COLOR_BUY clrGreen
#define COLOR_SELL clrRed
#define COLOR_BUY_STOP clrBlue
#define COLOR_SELL_STOP clrMagenta
#define COLOR_BUY_LIMIT clrAqua
#define COLOR_SELL_LIMIT clrPink

#endif
//+------------------------------------------------------------------+
