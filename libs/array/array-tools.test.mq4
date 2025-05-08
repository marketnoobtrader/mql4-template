#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link "https://www.mql5.com"
#property version "1.00"
#property strict

#include "array-tools.mqh"

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
   {
    int myArray[10];
// Fill array with a sequence starting from 1 with step 2
    if(ArrayTools::FillSequence(myArray, 1, 2))
        ArrayTools::Print(myArray, "FilledArray");
// Add an element to the array
    if(ArrayTools::Add(myArray, 100))
        Print("Added 100 to the array.");
// Print the array again after adding
    ArrayTools::Print(myArray, "AfterAdd");
// Insert element 999 at position 3
    if(ArrayTools::InsertAt(myArray, 3, 999))
        Print("Inserted 999 at position 3.");
// Print the array after insertion
    ArrayTools::Print(myArray, "AfterInsert");
// Remove element at position 2
    if(ArrayTools::RemoveAt(myArray, 2))
        Print("Removed element at position 2.");
// Final print
    ArrayTools::Print(myArray, "FinalArray");
    return (INIT_SUCCEEDED);
   }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
   {
//---
   }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
   {
//---
   }
//+------------------------------------------------------------------+
