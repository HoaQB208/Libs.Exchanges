namespace Libs.BaseExchange.Market
{
    public interface IBaseMarket
    {
        public MarketType MarketType { get; set; }

        public Task<List<string>> GetSymbols();
    }
}
