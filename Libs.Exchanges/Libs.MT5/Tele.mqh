void SendMessage(string botToken, string chatId, string message)
{
   string headers;
   char   post[], result[];
   string url = StringFormat("https://api.telegram.org/bot%s/sendMessage?chat_id=%s&text=%s&parse_mode=Markdown", botToken, chatId, message);
   WebRequest("GET", url, NULL, NULL, 500, post, 0, result, headers);
}