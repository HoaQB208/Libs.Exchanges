// Kiểm tra nến có màu xanh
bool IsGreenCandle(MqlRates &candle)
{
   return candle.close > candle.open;
}

// Kiểm tra nến có màu xanh
bool IsGreenCandle(int shift = 0)
{
   double open = iOpen(_Symbol, _Period, shift);
   double close = iClose(_Symbol, _Period, shift);
   return close > open;
}

// Kiểm tra nến có đóng ở nửa trên của cây nến
bool IsCandleCloseUpperHalf(int shift = 0)
{
   double high = iHigh(_Symbol, _Period, shift);
   double low = iLow(_Symbol, _Period, shift);
   double close = iClose(_Symbol, _Period, shift);
   double mid = (high + low) / 2.0;
   return close > mid;
}

// Kiểm tra các nến có hỗ trợ tín hiệu
bool IsCandleSupport(int side, int candleNumb = 1)
{
   for(int shift=0; shift<candleNumb; shift++)
   {
      double high = iHigh(_Symbol, _Period, shift);
      double low = iLow(_Symbol, _Period, shift);
      double close = iClose(_Symbol, _Period, shift);
      double mid = (high + low) / 2.0;
      if(side == 1 && close < mid) return false;
      if(side == -1 && close > mid) return false;
   }
   return true;
}

// Lấy time của nến
datetime GetTime(int shift = 0)
{
   return iTime(_Symbol, _Period, shift);
}

// Kiểm tra nếu gần đến thời điểm đóng nến
bool IsCandleNearClosing(ENUM_TIMEFRAMES timeframe, double remainRate = 0.1)
{
   double tfSeconds = PeriodSeconds(timeframe);
   double secondsBeforeClose = tfSeconds * remainRate;
   datetime currentTime = TimeCurrent();
   datetime candleCloseTime = iTime(NULL, timeframe, 0) + PeriodSeconds(timeframe);
   return currentTime >= candleCloseTime - secondsBeforeClose && currentTime <= candleCloseTime;
}

// Kiểm tra xem có phải vừa mới mở nến. Lưu ý: Dùng biến static nên chỉ được gọi 1 lần trong lượt check
bool IsNewOpen()
{
   static datetime lastChecked = 0;
   datetime openTime = iTime(_Symbol, _Period, 0);
   if (lastChecked == openTime) return false;
   lastChecked = openTime;
   return true;
}

// Kiểm tra xem có phải vừa mới mở nến
bool IsNewOpen(datetime &lastChecked)
{
   datetime openTime = iTime(_Symbol, _Period, 0);
   if (lastChecked == openTime) return false;
   lastChecked = openTime;
   return true;
}

//+------------------------------------------------------------------+
