using Libs.BaseExchange;
using Libs.Binance;
using System.Windows;

namespace Exchanges.Tester
{
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
            Test();
        }

        static async void Test()
        {
            IBaseExchange exchange = new BinanceExchange();
            var symbols = await exchange.Futures.GetSymbols();
            MessageBox.Show(symbols.Count.ToString());
        }
    }
}