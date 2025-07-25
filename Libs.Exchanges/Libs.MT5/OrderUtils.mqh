// Kiểm tra đã đặt lệnh chờ chưa
bool AnyOrder(int side = 0)
{
   int orders = OrdersTotal();
   if(orders == 0) return false;
   if(side == 0) return true;

   for(int i = 0; i < orders; i++)
   {
      ulong ticket = OrderGetTicket(i);
      if (!OrderSelect(ticket)) continue;

      int type = (int)OrderGetInteger(ORDER_TYPE);
      bool isBuy = type == ORDER_TYPE_BUY_LIMIT || type == ORDER_TYPE_BUY_STOP;
      bool isSell = type == ORDER_TYPE_SELL_LIMIT || type == ORDER_TYPE_SELL_STOP;
      if ((side == 1 && isBuy) || (side == -1 && isSell)) return true;
   }
   return false;
}
//+------------------------------------------------------------------+
