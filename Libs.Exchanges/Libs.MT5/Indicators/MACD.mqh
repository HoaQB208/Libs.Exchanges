// Lấy giá trị MACD hiện tại
void GetMACD(double &histogram, double &signal)
{
   int macdHandle = iMACD(_Symbol, _Period, 12, 26, 9, PRICE_CLOSE);
   double histogramBuffer[], signalBuffer[]; // Mới nhất ở cuối
   int copied = CopyBuffer(macdHandle, 0, 0, 1, histogramBuffer);
   if(copied == 1)
   {
      CopyBuffer(macdHandle, 1, 0, 1, signalBuffer);
      histogram = histogramBuffer[0];
      signal = signalBuffer[0];
   }
}

// Lấy danh sách giá trị MACD. Mới nhất ở cuối
bool GetMACD(double &histogram[], double &signal[], int numbOfCandle = 100)
{
   int macdHandle = iMACD(_Symbol, _Period, 12, 26, 9, PRICE_CLOSE);
   int copiedHis = CopyBuffer(macdHandle, 0, 0, numbOfCandle, histogram);
   int copiedSn = CopyBuffer(macdHandle, 1, 0, numbOfCandle, signal);
   IndicatorRelease(macdHandle);
   return copiedHis > 0 && copiedSn > 0;
}
//+------------------------------------------------------------------+
