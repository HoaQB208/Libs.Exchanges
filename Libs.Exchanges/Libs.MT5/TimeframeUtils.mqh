// Chuyển string sang Timeframe
ENUM_TIMEFRAMES StringToTimeframe(string tfStr)
{
   if(tfStr == "M1") return PERIOD_M1;
   if(tfStr == "M5") return PERIOD_M5;
   if(tfStr == "M15") return PERIOD_M15;
   if(tfStr == "M30") return PERIOD_M30;
   if(tfStr == "H1") return PERIOD_H1;
   if(tfStr == "H4") return PERIOD_H4;
   if(tfStr == "D1") return PERIOD_D1;
   if(tfStr == "W1") return PERIOD_W1;
   if(tfStr == "MN1") return PERIOD_MN1;
   return (ENUM_TIMEFRAMES)_Period;
}