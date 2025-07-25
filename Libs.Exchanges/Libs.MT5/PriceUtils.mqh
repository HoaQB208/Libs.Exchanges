// Lấy Spread
double GetSpread()
{
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   return ask - bid;
}

// Lấy khoảng giá của 1 cây nến
double GetCandleRange(ENUM_TIMEFRAMES timeframe, int shift = 0)
{
   double high = iHigh(_Symbol, timeframe, shift);
   double low = iLow(_Symbol, timeframe, shift);
   return high - low;
}

// Lấy khoảng giá của nhiều cây nến
double GetCandlesRange(ENUM_TIMEFRAMES timeframe, int numbOfKline)
{
   if(numbOfKline <= 0) return 0;
   MqlRates klines[];
   if (CopyRates(_Symbol, timeframe, 0, numbOfKline, klines) <= 0) return 0;
   double minLow = klines[0].low;
   double maxHigh = klines[0].high;
   for (int i = 1; i < numbOfKline; i++)
   {
      if (klines[i].low < minLow) minLow = klines[i].low;
      if (klines[i].high > maxHigh) maxHigh = klines[i].high;
   }
   return maxHigh - minLow;
}

//+------------------------------------------------------------------+
double GetCandlesMinMax(ENUM_TIMEFRAMES timeframe, int numbOfKline, double &minLow, double &maxHigh)
{
   if(numbOfKline <= 0) return 0;
   MqlRates klines[];
   if (CopyRates(_Symbol, timeframe, 0, numbOfKline, klines) <= 0) return 0;
   minLow = klines[0].low;
   maxHigh = klines[0].high;   
   for (int i = 1; i < numbOfKline; i++)
   {
      if (klines[i].low < minLow) minLow = klines[i].low;
      if (klines[i].high > maxHigh) maxHigh = klines[i].high;
   }
   double curPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   return (curPrice - minLow) / (maxHigh - minLow);
}

// Lấy khoảng giá trung bình các nến
double GetAveRange(ENUM_TIMEFRAMES timeframe, int numbOfKline)
{
   if(numbOfKline <= 0) return 0;
   MqlRates klines[];
   if (CopyRates(_Symbol, timeframe, 0, numbOfKline, klines) <= 0) return 0;
   double sum = 0;
   for (int i = 0; i < numbOfKline; i++)
   {
      sum += klines[i].high - klines[i].low;
   }
   return sum / numbOfKline;
}

// Lấy giá khi mở lệnh ngày
double GetMarketEntryPrice(int side)
{
   return side == -1 ? SymbolInfoDouble(_Symbol, SYMBOL_BID) : SymbolInfoDouble(_Symbol, SYMBOL_ASK);
}

// Tính giá TP/SL khi có số pip và side
void GetTPSLPrices(int side, double pip, double &tp, double &sl, double scaleTP = 1, double scaleSL = 1)
{
   double entryPrice = GetMarketEntryPrice(side);
   if(side == 1) // Buy
   {
      tp = entryPrice + pip * scaleTP;
      sl = entryPrice - pip * scaleSL;
   }
   else // Sell
   {
      tp = entryPrice - pip * scaleTP;
      sl = entryPrice + pip * scaleSL;
   }
}
//+------------------------------------------------------------------+
