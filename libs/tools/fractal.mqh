//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#ifndef __FRACTAL_MQH__
#define __FRACTAL_MQH__


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int GetLastUpperFractalIndex(string symbol, int timeframe, int maxBarsToCheck = 100)
   {
    for(int i = 2; i < maxBarsToCheck; i++)  // start from 2 due to fractal delay
       {
        double value = iFractals(symbol, timeframe, MODE_UPPER, i);
        if(value != EMPTY_VALUE)
            return i;
       }
    return -1; // not found
   }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int GetLastLowerFractalIndex(string symbol, int timeframe, int maxBarsToCheck = 100)
   {
    for(int i = 2; i < maxBarsToCheck; i++)  // start from 2 due to fractal delay
       {
        double value = iFractals(symbol, timeframe, MODE_LOWER, i);
        if(value != EMPTY_VALUE)
            return i;
       }
    return -1; // not found
   }


#endif

/* Usage:

void OnTick()
{
   int upperFractalIndex = GetLastUpperFractalIndex(Symbol(), PERIOD_CURRENT);
   int lowerFractalIndex = GetLastLowerFractalIndex(Symbol(), PERIOD_CURRENT);

   if (upperFractalIndex != -1)
      Print("Last upper fractal at index: ", upperFractalIndex);

   if (lowerFractalIndex != -1)
      Print("Last lower fractal at index: ", lowerFractalIndex);
}

*/



//+------------------------------------------------------------------+
