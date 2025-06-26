using Libs.BaseExchange.Market;

namespace Libs.BaseExchange
{
    public interface IBaseExchange
    {
        public Exchange Name { get; }
        public IBaseMarket Futures { get; }
    }
}
