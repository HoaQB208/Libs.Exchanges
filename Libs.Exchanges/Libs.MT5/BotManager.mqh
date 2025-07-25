// Kiểm tra có thể chạy bot. ExpirationTime có cú pháp: D'2025.10.30 00:00:00'
bool CheckCanRun(datetime expirationTime, string &urls[])
{
   bool isCanRun = true;
   string botName = MQLInfoString(MQL_PROGRAM_NAME);

// Kiểm tra hết hạn
   isCanRun = TimeCurrent() < expirationTime;
   if(!isCanRun) Alert("❌ " + botName + " has expired.");

// Kiểm tra cần bật Allow Url
   for(int i = 0; i < ArraySize(urls); i++)
   {
      bool ok = CheckUrl(urls[i]);
      if(!ok) return false;
   }

   if(isCanRun) printf("✅ " + botName + " has started");
   return isCanRun;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CheckUrl(string url)
{
   string headers;
   char   post[], result[];
   int responseCode = WebRequest("GET", url, NULL, NULL, 500, post, 0, result, headers);
   bool isOK = responseCode > 0; // Số âm là k thành công
   if(!isOK)
   {
      Alert("Vào Tools -> Options -> Expert Advisors:\nTích vào Allow WebRequest...\nvà thêm " + url + " vào danh sách");
   }
   return isOK;
}

//+------------------------------------------------------------------+
