class PriceWorker
  include Sidekiq::Worker

  def perform(*args)
    # Do something
    price_coin_usd = JSON.parse(URI.parse('https://min-api.cryptocompare.com/data/pricemulti?fsyms=BTC,ETH,XRP,LTC&tsyms=USD').read, :symbolize_names => true)
    BtcHistory.create(price: price_coin_usd[:BTC][:USD])
    EthHistory.create(price: price_coin_usd[:ETH][:USD])
    XrpHistory.create(price: price_coin_usd[:XRP][:USD])
    LtcHistory.create(price: price_coin_usd[:LTC][:USD])

    PriceWorker.perform_in(10.seconds)
  end
end
