using Binance.Net.Clients;
using Libs.BaseExchange;
using Libs.BaseExchange.Market;

namespace Libs.Binance.Market.Futures
{
    public class FuturesMarket : IBaseMarket
    {
        public MarketType MarketType { get; set; } = MarketType.Futures;

        public async Task<List<string>> GetSymbols()
        {
            List<string> symbols = new();
            var get = await new BinanceRestClient().UsdFuturesApi.ExchangeData.GetTickersAsync();
            if (get.Success)
            {
                symbols = get.Data.Where(x => x.Symbol.EndsWith("USDT")).Select(x => x.Symbol).ToList();
            }
            return symbols;
        }
    }
}
