//+------------------------------------------------------------------+
//|                                                 array-tools.mqh |
//|                                       Copyright 2025, Your Name |
//|                                             https://example.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Your Name"
#property link "https://example.com"
#property version "1.00"
#property strict

//+------------------------------------------------------------------+
//| ArrayTools class - OOP approach to array manipulation            |
//+------------------------------------------------------------------+
class ArrayTools
   {

public:
                     ArrayTools() {}
                    ~ArrayTools() {}

    //+------------------------------------------------------------------+
    //| Fills array with a sequence of values                            |
    //+------------------------------------------------------------------+
    template <typename T>
    static bool      FillSequence(T &array[], T start_value, T step)
       {
        int size = ArraySize(array);
        if(size <= 0)
            return false;
        T current_value = start_value;
        for(int i = 0; i < size; i++)
           {
            array[i] = current_value;
            current_value += step;
           }
        return true;
       }

    //+------------------------------------------------------------------+
    //| Prints array contents (for debugging)                            |
    //+------------------------------------------------------------------+
    template <typename T>
    static void      Print(const T &array[], string array_name = "Array", int start_pos = 0, int count = WHOLE_ARRAY)
       {
        int size = ArraySize(array);
        if(size <= 0)
           {
            PrintFormat("%s: Empty array", array_name);
            return;
           }
        if(count == WHOLE_ARRAY)
            count = size - start_pos;
        if(start_pos < 0 || start_pos >= size || count <= 0 || start_pos + count > size)
           {
            PrintFormat("%s: Invalid parameters", array_name);
            return;
           }
        PrintFormat("%s[%d] contents:", array_name, count);
        for(int i = start_pos; i < start_pos + count; i++)
           {
            PrintFormat("  [%d] = %s", i, (string)array[i]);
           }
       }

    template <typename T>
    static bool      Add(T &array[], T value, int reserve_size = 0)
       {
        const int size = ArraySize(array);
        if(!ArrayResize(array, size + 1, reserve_size))
            return false;
        array[size] = value;
        return true;
       }

    template <typename T>
    static int       RemoveAt(T &array[], int pos, int reserve_size = 0)
       {
        const int size = ArraySize(array);
        if(pos < 0 || pos >= size)
            return false;
        for(int i = pos; i < size - 1; i++)
            array[i] = array[i + 1];
        return ArrayResize(array, size - 1, reserve_size);
       }

    template <typename T>
    static bool      InsertAt(T &array[], int pos, T value, int reserve_size = 0)
       {
        const int size = ArraySize(array);
        if(pos < 0 || pos > size)
            return false;
        if(!ArrayResize(array, size + 1, reserve_size))
            return false;
        for(int i = size; i > pos; i--)
            array[i] = array[i - 1];
        array[pos] = value;
        return true;
       }
   };

//+------------------------------------------------------------------+
