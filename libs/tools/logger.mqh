//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#ifndef __LOGGER_MQH__
#define __LOGGER_MQH__

enum ENUM_LogLevel
   {
    LOG_DEBUG = 0,
    LOG_INFO = 1,
    LOG_WARN = 2,
    LOG_ERROR = 3
   };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CLogger
   {
private:
    ENUM_LogLevel    level;
    string           prefix;
    static CLogger   *instance;

public:
                     CLogger(ENUM_LogLevel lvl)
       {
        setLevel(lvl);
       }

    static CLogger   *GetInstance()
       {
        if(instance == NULL)
           {
            instance = new CLogger(LOG_DEBUG);
           }
        return instance;
       }

    void             setLevel(ENUM_LogLevel lvl)
       {
        level = lvl;
       }

    void             log(ENUM_LogLevel msgLevel, string msg)
       {
        if(msgLevel < level)
            return;
        switch(msgLevel)
           {
            case LOG_DEBUG:
                prefix = "[DEBUG] ";
                break;
            case LOG_INFO:
                prefix = "[INFO]  ";
                break;
            case LOG_WARN:
                prefix = "[WARN]  ";
                break;
            case LOG_ERROR:
                prefix = "[ERROR] ";
                break;
           }
        Print(prefix + msg);
       }

    void             LogToFile(string msg)
       {
        int file = FileOpen("mql-log.txt", FILE_WRITE | FILE_TXT | FILE_COMMON);
        if(file != INVALID_HANDLE)
           {
            FileSeek(file, 0, SEEK_END);
            FileWrite(file, TimeToString(TimeCurrent(), TIME_DATE | TIME_MINUTES) + " - " + msg);
            FileClose(file);
           }
       }
   };

CLogger *CLogger::instance = NULL;

#endif

