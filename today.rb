#!/usr/bin/env ruby
# Id$ nonnax 2021-11-19 10:15:08 +0800
require 'aitch'
require 'arraycsv'
require 'array_table'

root="/home/seti/ruby-sandbox/github/coinbank/"
data_file=root+"market_#{Time.now.yday}.csv"
json_file=root+"market_#{Time.now.yday}.json"

KEYS=%i[id current_price high_24h low_24h price_change_percentage_24h price_change_percentage_7d_in_currency price_change_percentage_14d_in_currency price_change_percentage_30d_in_currency market_cap_change_percentage_24h]

def get(coins=%i[bitcoin ethereum chainlink litecoin uniswap])
    # url="https://api.coingecko.com/api/v3/coins/litecoin/market_chart?vs_currency=php&days=30&interval=daily"
    url="https://api.coingecko.com/api/v3/coins/markets?vs_currency=php&ids=#{coins.join(',')}&order=market_cap_desc&per_page=100&page=1&sparkline=false&price_change_percentage=24h,7d,14d,30d,90d"
    # url="https://api.coingecko.com/api/v3/coins/markets?vs_currency=php&ids=bitcoin,ethereum,litecoin,ripple,chainlink,uniswap&order=market_cap_desc&per_page=100&page=1&sparkline=false&price_change_percentage=24h,7d,14d,30d"
    res=Aitch.get(url)
    jdata=JSON.parse(res.body, symbolize_names: true)
    # jdata=JSON.parse(res.body, create_additions: true)
    # data=res.data
    # keys=%i[id current_price high_24h low_24h price_change_percentage_24h price_change_percentage_14d_in_currency price_change_percentage_30d_in_currency]
    [jdata.map{|coin| coin.values_at(*KEYS)}, jdata]
end

data=ArrayCSV.new(data_file, 'w')
data.dataframe, jdata=get()
data.dataframe.prepend KEYS.map{|k| 
  k.to_s
    .gsub(/change_percentage_/,'ch_')
    .gsub(/in_currency/,'php')
  }
data.save
# puts JSON.pretty_generate( jdata)
puts IO.popen("csv_table #{data_file}", &:read)
# puts data.dataframe.to_table
