//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#include "logger.mqh"

// Input to set log level from the terminal
input ENUM_LogLevel logLevel = LOG_DEBUG;

// Global logger pointer
CLogger *logger = NULL;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
   {
    logger = CLogger::GetInstance(); // Get the singleton logger instance
    logger.setLevel(logLevel);       // Set the desired log level
    logger.log(LOG_DEBUG, "Expert initialized.");
    logger.log(LOG_INFO, "Logging started at INFO level.");
    logger.log(LOG_WARN, "This is a warning message.");
    logger.log(LOG_ERROR, "This is an error message.");
// Optional: also log to file
    logger.LogToFile("Expert started and logging initialized.");
    return (INIT_SUCCEEDED);
   }

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
   {
    if(logger != NULL)
       {
        logger.LogToFile("Expert is shutting down.");
        delete logger;
        logger = NULL;
       }
   }

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
   {
    logger.log(LOG_DEBUG, "New tick received: " + DoubleToString(Bid, 5));
   }
//+------------------------------------------------------------------+
