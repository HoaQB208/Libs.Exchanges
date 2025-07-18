//+------------------------------------------------------------------+
#include <Trade\Trade.mqh>

// int positions = PositionsTotal();


// Lấy PnL toàn bộ vị thế
double GetTotalPnL()
{
   double sumPnL = 0;
   int positions = PositionsTotal();
   for(int i = 0; i < positions; i++)
   {
      if(PositionSelectByTicket(PositionGetTicket(i)))
      {
         sumPnL += PositionGetDouble(POSITION_PROFIT);
      }
   }
   return sumPnL;
}

// Đóng hết vị thế
void ClosePositions(CTrade &cTrade, int side = 0)
{
   for (int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if (!PositionSelectByTicket(ticket)) continue;
      bool isBuy = PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY;
      if (side == 0 || (side == 1 && isBuy) || (side == -1 && !isBuy))
      {
         cTrade.PositionClose(ticket);
      }
   }
}


// Chỉ đóng vị thế lãi
void CloseWinPositions(CTrade &cTrade, int side = 0, double minPnL = 0.5, double limitClosedLot = 9999)
{
   double sumClosedLot = 0;
   for (int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if (!PositionSelectByTicket(ticket)) continue;

      double pnl = PositionGetDouble(POSITION_PROFIT);
      if(pnl > minPnL)
      {
         bool isBuy = PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY;
         if (side == 0 || (side == 1 && isBuy) || (side == -1 && !isBuy))
         {
            double lotSize = PositionGetDouble(POSITION_VOLUME);
            if(cTrade.PositionClose(ticket))
            {
               sumClosedLot += lotSize;
               if(sumClosedLot >= limitClosedLot) return;
            }
         }
      }
   }
}


// Đóng hết vị thế nếu đang lãi
bool ClosePositionsIfWin(CTrade &cTrade, double minPnL = 0.5)
{
   if(GetTotalPnL() > minPnL)
   {
      ClosePositions(cTrade);
      return true;
   }
   return false;
}


// Đóng hết lệnh chờ
void CloseOrders(CTrade &cTrade, int side = 0)
{
   for (int i = OrdersTotal() - 1; i >= 0; i--)
   {
      ulong ticket = OrderGetTicket(i);
      if (!OrderSelect(ticket)) continue;

      int type = (int)OrderGetInteger(ORDER_TYPE);
      bool isBuy = type == ORDER_TYPE_BUY_LIMIT || type == ORDER_TYPE_BUY_STOP;
      bool isSell = type == ORDER_TYPE_SELL_LIMIT || type == ORDER_TYPE_SELL_STOP;
      if (side == 0 || (side == 1 && isBuy) || (side == -1 && isSell))
      {
         cTrade.OrderDelete(ticket);
      }
   }
}


// Đóng hết vị thế và lệnh chờ
void ClosePositionsAndOrders(CTrade &cTrade, int side = 0)
{
   ClosePositions(cTrade, side);
   CloseOrders(cTrade, side);
}

// Mở vị thế mới
bool OpenPosition(CTrade &cTrade, int signal, double lotSize, double sl = 0, double tp = 0)
{
   if(signal == 1)
   {
      return cTrade.Buy(lotSize, _Symbol, 0, sl, tp);
   }
   else if(signal == -1)
   {
      return cTrade.Sell(lotSize, _Symbol, 0, sl, tp);
   }
   return false;
}

// Mở vị thế mới nhưng nhược với tín hiệu gốc (Đổi Buy-Sell, TP-SL ngược lại)
bool OpenOppositePosition(CTrade &cTrade, int signal, double lotSize, double sl = 0, double tp = 0)
{
   if(signal == 1)
   {
      return cTrade.Sell(lotSize, _Symbol, 0, tp, sl);
   }
   else if(signal == -1)
   {
      return cTrade.Buy(lotSize, _Symbol, 0, tp, sl);
   }
   return false;
}

// Xem lệnh đóng gần nhất có phải là lệnh lãi
bool IsLastClosedPositionWin(int &side)
{
   side = 0;
   if(HistorySelect(0, TimeCurrent()))
   {
      int totalHistoryDeals = HistoryDealsTotal();
      for(int i = totalHistoryDeals - 1; i >= 0; i--)
      {
         ulong ticket = HistoryDealGetTicket(i);
         if(ticket == 0) continue;
         long dealType = HistoryDealGetInteger(ticket, DEAL_TYPE);
         if(dealType == DEAL_TYPE_BUY || dealType == DEAL_TYPE_SELL)
         {
            long entry = HistoryDealGetInteger(ticket, DEAL_ENTRY);
            if(entry == DEAL_ENTRY_OUT) // Chỉ khi đóng lệnh
            {
               side = dealType == DEAL_TYPE_BUY ? -1 : 1;
               double profit = HistoryDealGetDouble(ticket, DEAL_PROFIT);
               return profit >= 0;
            }
         }
      }
   }
   return true;
}

// Lệnh đóng gần nhất có side gì
int GetLastClosedPositionSide()
{
   if(HistorySelect(0, TimeCurrent()))
   {
      int totalHistoryDeals = HistoryDealsTotal();
      for(int i = totalHistoryDeals - 1; i >= 0; i--)
      {
         ulong ticket = HistoryDealGetTicket(i);
         if(ticket == 0) continue;
         long dealType = HistoryDealGetInteger(ticket, DEAL_TYPE);
         if(dealType == DEAL_TYPE_BUY || dealType == DEAL_TYPE_SELL)
         {
            long entry = HistoryDealGetInteger(ticket, DEAL_ENTRY);
            if(entry == DEAL_ENTRY_OUT) // Chỉ khi đóng lệnh
            {
               return dealType == DEAL_TYPE_BUY ? -1 : 1;
            }
         }
      }
   }
   return 0;
}

// Vị thế đang mở mới mở có đang lãi
bool IsLastOpeningPositionWin(int &side)
{
   side = 0;
   int positions = PositionsTotal();
   if(positions > 0)
   {
      if(PositionSelectByTicket(PositionGetTicket(positions - 1)))
      {
         side = PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY ? 1 : -1;
         return PositionGetDouble(POSITION_PROFIT) > 0;
      }
   }
   return true;
}

// Lấy giá vào lệnh của vị thế đang mở đầu tiên
double GetFirstOpeningPositionPrice()
{
   if(PositionsTotal() > 0)
   {
      if(PositionSelectByTicket(PositionGetTicket(0)))
      {
         return PositionGetDouble(POSITION_PRICE_OPEN);
      }
   }
   return 0;
}

// Lấy giá vào lệnh lớn nhất của các vị thế đang mở
double GetMaxOpeningSellPositionPrice()
{
   int n = PositionsTotal();
   if(n == 0) return 0;
   double max = 0;
   for(int i = 0; i < n; i++)
   {
      if(PositionSelectByTicket(PositionGetTicket(i)))
      {
         if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
         {
            double p = PositionGetDouble(POSITION_PRICE_OPEN);
            if(p > max) max = p;
         }
      }
   }
   return max;
}

// Lấy giá vào lệnh nhỏ nhất của các vị thế đang mở
double GetMinOpeningBuyPositionPrice()
{
   int n = PositionsTotal();
   if(n == 0) return 0;
   double min = 9999999;
   for(int i = 0; i < n; i++)
   {
      if(PositionSelectByTicket(PositionGetTicket(i)))
      {
         if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
         {
            double p = PositionGetDouble(POSITION_PRICE_OPEN);
            if(p < min) min = p;
         }
      }
   }
   return  min == 9999999 ? 0 : min;
}


// Lấy giá vị thế gần giá hiện tại nhất
double GetNearOpeningPositionPrice(double curPrice, int side = 0)
{
   int n = PositionsTotal();
   if(n == 0) return 0;
   double price = 0;
   double minDis = 99999;
   for(int i = 0; i < n; i++)
   {
      if(PositionSelectByTicket(PositionGetTicket(i)))
      {
         int poSide = PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY ? 1 : -1;
         if(side != 0 && side != poSide) continue;
         double p = PositionGetDouble(POSITION_PRICE_OPEN);
         double d = MathAbs(curPrice - p);
         if(d < minDis)
         {
            minDis = d;
            price = p;
         }
      }
   }
   return price;
}


// Lấy giá lệnh chờ đang mở đầu tiên
double GetFirstOpeningOrderPrice()
{
   if(OrdersTotal() > 0)
   {
      if(OrderSelect(OrderGetTicket(0)))
      {
         return OrderGetDouble(ORDER_PRICE_OPEN);
      }
   }
   return 0;
}

// Lấy giá lớn nhất của các lệnh chờ đang mở
double GetMaxOpeningSellOrderPrice()
{
   int n = OrdersTotal();
   if(n == 0) return 0;
   double max = 0;
   for(int i = 0; i < n; i++)
   {
      if(OrderSelect(OrderGetTicket(i)))
      {
         if(OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_SELL_STOP)
         {
            double p = OrderGetDouble(ORDER_PRICE_OPEN);
            if(p > max) max = p;
         }
      }
   }
   return max;
}

// Lấy giá nhỏ nhất của các lệnh chờ đang mở
double GetMinOpeningBuyOrderPrice()
{
   int n = OrdersTotal();
   if(n == 0) return 0;

   double min = 99999999;
   for(int i = 0; i < n; i++)
   {
      if(OrderSelect(OrderGetTicket(i)))
      {
         if(OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_BUY_STOP)
         {
            double p = OrderGetDouble(ORDER_PRICE_OPEN);
            if(p < min) min = p;
         }
      }
   }
   return min == 99999999 ? 0 : min;
}

// Lấy tổng lot của mỗi side các vị thế đang mở
void GetOpeningPositionLot(double &sumBuy, double &sumSell)
{
   sumBuy = 0;
   sumSell = 0;
   int positions = PositionsTotal();
   for(int i = 0; i < positions; i++)
   {
      if(PositionSelectByTicket(PositionGetTicket(i)))
      {
         double lotSize = PositionGetDouble(POSITION_VOLUME);
         if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) sumBuy += lotSize;
         else sumSell += lotSize;
      }
   }
}

// Lấy tổng lot, pnl của mỗi side các vị thế đang mở
void GetOpeningPositionLotPnL(double &sumBuy, double &sumSell, double &buyPnL, double &sellPnL, int &countBuy, int &countSell)
{
   sumBuy = 0; sumSell = 0; buyPnL = 0; sellPnL = 0; countBuy = 0; countSell = 0;
   int positions = PositionsTotal();
   for(int i = 0; i < positions; i++)
   {
      if(PositionSelectByTicket(PositionGetTicket(i)))
      {
         double pnl = PositionGetDouble(POSITION_PROFIT);
         double lotSize = PositionGetDouble(POSITION_VOLUME);
         if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
         {
            sumBuy += lotSize;
            buyPnL += pnl;
            countBuy++;
         }
         else
         {
            sumSell += lotSize;
            sellPnL += pnl;
            countSell++;
         }
      }
   }
}

// Lấy side vị thế vừa mở
int GetLastPositionSide()
{
   int positions = PositionsTotal();
   if(positions > 0)
   {
      if(PositionSelectByTicket(PositionGetTicket(positions - 1)))
      {
         return PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY ? 1 : -1;
      }
   }
   return 0;
}

// Lấy giá vào của vị thế vừa mở
double GetLastPositionPrice()
{
   int positions = PositionsTotal();
   if(positions > 0)
   {
      if(PositionSelectByTicket(PositionGetTicket(positions - 1)))
      {
         return PositionGetDouble(POSITION_PRICE_OPEN);
      }
   }
   return 0;
}

// Lấy side vị thế vừa mở
int GetLastOrderSide()
{
   int orders = OrdersTotal();
   if(orders > 0)
   {
      if(OrderSelect(OrderGetTicket(orders - 1)))
      {
         return OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_BUY ? 1 : -1;
      }
   }
   return 0;
}
//+------------------------------------------------------------------+
