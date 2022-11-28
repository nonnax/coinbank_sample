#!/usr/bin/env ruby
# Id$ nonnax 2022-11-28 20:11:10

PRICE_CHANGE_PERCENTAGE_24H = 4

KEYS = %i[
  id current_price high_24h low_24h price_change_percentage_24h
  price_change_percentage_7d_in_currency price_change_percentage_14d_in_currency
  price_change_percentage_30d_in_currency market_cap_change_percentage_24h
].freeze
def header_keys
  KEYS
    .map(&:to_s)
    .lazy
    .map { |k| k.gsub(/change_percentage_/, 'ch_').gsub(/in_currency/, 'php') }
    .to_a
end

def get(coins = %i[bitcoin bitcoin-cash ethereum chainlink litecoin ripple uniswap])
  url = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=php&ids=#{coins.join(',')}&order=market_cap_desc&per_page=100&page=1&sparkline=false&price_change_percentage=24h,7d,14d,30d,90d"

  Faraday.get(url)
         .then { |res| JSON.parse(res.body, symbolize_names: true) }
         .map { |coin| coin.values_at(*KEYS) }
end
