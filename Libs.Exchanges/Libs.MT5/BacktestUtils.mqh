#include <Trade\Trade.mqh>

// Kiểm tra hết tiền thì dừng backtest sớm
void NotEnoughMoney(CTrade &ctrade, bool &canTrading)
{
   if (ctrade.ResultRetcode() == TRADE_RETCODE_NO_MONEY)
   {
      canTrading = false;
      printf("Dừng backtest vì không đủ tiền vào lệnh");
   }
}


// const bool IsBacktest = MQLInfoInteger(MQL_TESTER); // Phân biệt chế độ Backtest hay Trade (Demo, Real)