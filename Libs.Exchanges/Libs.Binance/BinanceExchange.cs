using Libs.BaseExchange;
using Libs.BaseExchange.Market;
using Libs.Binance.Market.Futures;

namespace Libs.Binance
{
    public class BinanceExchange : IBaseExchange
    {
        public Exchange Name {  get; } = Exchange.Binance;
        public IBaseMarket Futures { get; } = new FuturesMarket();
    }
}
