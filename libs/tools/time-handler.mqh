//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#ifndef __TIME_HANDLER_MQH__
#define __TIME_HANDLER_MQH__

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class NewCandleObserver
{
private:
   ENUM_TIMEFRAMES m_timeframe;
   datetime m_lastCandleTime;

public:
   NewCandleObserver(ENUM_TIMEFRAMES timeframe = PERIOD_CURRENT)
   {
      m_timeframe = timeframe;
      m_lastCandleTime = 0;
   }

   bool IsNewCandle()
   {
      datetime currentCandleTime = iTime(Symbol(), m_timeframe, 0);
      if (currentCandleTime != m_lastCandleTime)
      {
         m_lastCandleTime = currentCandleTime;
         return true;
      }
      return false;
   }

   void SetTimeframe(ENUM_TIMEFRAMES timeframe)
   {
      m_timeframe = timeframe;
      m_lastCandleTime = 0;
   }

   datetime GetCandleTime(int index = 0) const
   {
      return iTime(Symbol(), m_timeframe, index);
   }

   int GetTimeRemainingInCandle(int index = 0) const
   {
      datetime currentServerTime = TimeCurrent();
      datetime nextCandleTime = GetCandleTime(index) + PeriodSeconds(m_timeframe);
      return (int)(nextCandleTime - currentServerTime);
   }

   string GetFormattedTimeRemaining(int index = 0) const
   {
      int seconds = GetTimeRemainingInCandle(index);
      int minutes = seconds / 60;
      seconds = seconds % 60;
      return StringFormat("%02d:%02d", minutes, seconds);
   }
};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class EnhancedTimeHandler
{
private:
   datetime m_tradingStartTime;
   datetime m_tradingEndTime;

   // Helper function to convert time string to seconds since midnight
   int TimeStringToSeconds(string timeStr)
   {
      // Expected format: "HH:MM:SS"
      string parts[];
      int count = StringSplit(timeStr, ':', parts);
      if (count != 3)
         return -1; // Invalid format
      int hours = (int)StringToInteger(parts[0]);
      int minutes = (int)StringToInteger(parts[1]);
      int seconds = (int)StringToInteger(parts[2]);
      return hours * 3600 + minutes * 60 + seconds;
   }

   // Create datetime from current date and time string
   datetime CreateDatetimeFromTimeString(string timeStr)
   {
      datetime currentTime = TimeCurrent();
      MqlDateTime struct_time;
      TimeToStruct(currentTime, struct_time);
      // Parse time string
      string parts[];
      StringSplit(timeStr, ':', parts);
      int hours = (int)StringToInteger(parts[0]);
      int minutes = (int)StringToInteger(parts[1]);
      int seconds = (int)StringToInteger(parts[2]);
      // Create new datetime with current date but specified time
      struct_time.hour = hours;
      struct_time.min = minutes;
      struct_time.sec = seconds;
      return StructToTime(struct_time);
   }

public:
   EnhancedTimeHandler(string startTimeStr, string endTimeStr)
   {
      m_tradingStartTime = 0;
      m_tradingEndTime = 0;
      m_tradingStartTime = CreateDatetimeFromTimeString(startTimeStr);
      m_tradingEndTime = CreateDatetimeFromTimeString(endTimeStr);
      // Handle overnight trading sessions
      if (m_tradingEndTime < m_tradingStartTime)
      {
         // Add one day to the end time
         MqlDateTime struct_time;
         TimeToStruct(m_tradingEndTime, struct_time);
         struct_time.day += 1;
         m_tradingEndTime = StructToTime(struct_time);
      }
   }

   // Update the trading time window dates to current day
   void UpdateTradingTimeWindow()
   {
      if (m_tradingStartTime == 0 || m_tradingEndTime == 0)
         return;
      datetime current = TimeCurrent();
      MqlDateTime currentStruct, startStruct, endStruct;
      TimeToStruct(current, currentStruct);
      TimeToStruct(m_tradingStartTime, startStruct);
      TimeToStruct(m_tradingEndTime, endStruct);
      // Update start time to current date
      startStruct.year = currentStruct.year;
      startStruct.mon = currentStruct.mon;
      startStruct.day = currentStruct.day;
      m_tradingStartTime = StructToTime(startStruct);
      // Update end time to current date
      endStruct.year = currentStruct.year;
      endStruct.mon = currentStruct.mon;
      endStruct.day = currentStruct.day;
      // Handle overnight trading sessions
      if (startStruct.hour > endStruct.hour ||
          (startStruct.hour == endStruct.hour && startStruct.min > endStruct.min))
      {
         endStruct.day += 1;
      }
      m_tradingEndTime = StructToTime(endStruct);
   }

   // Check if current time is within trading window
   bool IsWithinTradingHours()
   {
      UpdateTradingTimeWindow();
      datetime currentTime = TimeCurrent();
      return (currentTime >= m_tradingStartTime && currentTime <= m_tradingEndTime);
   }

   // Get time until trading session starts (in seconds)
   int GetTimeUntilTradingStarts()
   {
      UpdateTradingTimeWindow();
      datetime currentTime = TimeCurrent();
      if (currentTime < m_tradingStartTime)
         return (int)(m_tradingStartTime - currentTime);
      else
         return 0; // Trading already started
   }

   // Get time until trading session ends (in seconds)
   int GetTimeUntilTradingEnds()
   {
      UpdateTradingTimeWindow();
      datetime currentTime = TimeCurrent();
      if (currentTime < m_tradingEndTime)
         return (int)(m_tradingEndTime - currentTime);
      else
         return 0; // Trading already ended
   }
};

#endif
