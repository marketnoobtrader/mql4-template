//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#include "defines.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void commentInfo()
   {
    Comment(NL + "$" + _Symbol + "   #Spread: " + string(SPREAD) + " @ " + (string)TimeCurrent() + NL
            + "+-------------------------------------------------------" + NL
            + "|<<ACCOUNT INFORMATION>>" + NL
            + "|Account Name:     " + AccountName() + NL
            + "|Broker Name:      " + AccountCompany() + NL
            + "|Server Name:      " + AccountServer() + NL
            + "|Currency:         " + AccountCurrency() + NL
            + "|Account Leverage: " + DoubleToStr(AccountLeverage(), 0) + NL
            + "+-------------------------------------------------------" + NL
            + "|Account Balance:  " + DoubleToStr(AccountBalance(), 2) + NL
            + "|Account Equity:   " + DoubleToStr(AccountEquity(), 2) + NL
            + "|Free Margin:      " + DoubleToStr(AccountFreeMargin(), 2) + NL
            + "|Used Margin:      " + DoubleToStr(AccountMargin(), 2) + NL
            + "|Account Profit:   " + DoubleToStr(AccountProfit(), 2) + NL
            + "+-------------------------------------------------------");
   }
//+------------------------------------------------------------------+
