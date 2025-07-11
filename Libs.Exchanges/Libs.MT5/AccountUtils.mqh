// Số dư tài khoản tại mốc thời gian
struct BalanceNode
{
   datetime time;
   double balance;
};

// Lấy lịch sử biến động tài khoản. Số lệnh, số lot đã giao dịch
void GetBalanceHistory(BalanceNode &nodes[], int &totalOrders, double &totalLots)
{
   if(HistorySelect(0, TimeCurrent()))
   {
      // Số tiền hiện tại
      double equity = AccountInfoDouble(ACCOUNT_EQUITY);
      BalanceNode lastNode;
      lastNode.time = TimeCurrent();
      lastNode.balance = equity;
      ArrayResize(nodes, 1);
      nodes[0] = lastNode;
      // Số tiền đã ghi nhận
      double balance = AccountInfoDouble(ACCOUNT_BALANCE);
      // Duyệt lịch sử giao dịch
      int totalHistoryDeals = HistoryDealsTotal();
      for(int i = totalHistoryDeals - 1; i >= 0; i--)
      {
         ulong ticket = HistoryDealGetTicket(i);
         if(ticket == 0) continue;

         long dealType = HistoryDealGetInteger(ticket, DEAL_TYPE);
         //if(dealType == DEAL_TYPE_CORRECTION) return;
         //if(dealType == DEAL_TYPE_BALANCE)
         //{
            //string comment = HistoryDealGetString(ticket, DEAL_COMMENT);
            //if(comment != "D-NULL") return;
         //}
         if(dealType == DEAL_TYPE_BALANCE || dealType == DEAL_TYPE_CORRECTION)
         {
            int size = ArraySize(nodes);
            BalanceNode node0;
            node0.time = nodes[size-1].time - 600; //datetime startTime = (datetime)HistoryDealGetInteger(ticket, DEAL_TIME);
            node0.balance = balance;
            ArrayResize(nodes, size + 1);
            nodes[size] = node0;
            return;
         }
         // Chỉ các deals thực sự (không phải điều chỉnh số tiền, nạp/rút)
         if(dealType == DEAL_TYPE_BUY || dealType == DEAL_TYPE_SELL)
         {
            long entry = HistoryDealGetInteger(ticket, DEAL_ENTRY);
            if(entry == DEAL_ENTRY_OUT) // Chỉ khi đóng lệnh
            {
               datetime closeTime = (datetime)HistoryDealGetInteger(ticket, DEAL_TIME);
               double profit = HistoryDealGetDouble(ticket, DEAL_PROFIT);
               double commission = HistoryDealGetDouble(ticket, DEAL_COMMISSION);
               double swap = HistoryDealGetDouble(ticket, DEAL_SWAP);
               double netProfit = profit + commission + swap;
               BalanceNode node;
               node.time = closeTime;
               node.balance = balance;
               int size = ArraySize(nodes);
               ArrayResize(nodes, size + 1);
               nodes[size] = node;
               // Giảm số dư về trước lúc chưa ghi nhận
               balance -= netProfit;
            }
            // Chỉ đếm khi vào lệnh (không đếm khi đóng lệnh)
            if(entry == DEAL_ENTRY_IN || entry == DEAL_ENTRY_INOUT)
            {
               totalOrders++;
               totalLots += HistoryDealGetDouble(ticket, DEAL_VOLUME);
            }
         }
      }
   }
}
//+------------------------------------------------------------------+
