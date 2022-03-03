#!/usr/bin/env -S ruby --jit
# Id$ nonnax 2021-11-19 10:15:08 +0800
require 'httparty'
require 'rubytools/array_csv'
require 'rubytools/array_table'
require 'rubytools/thread_ext'

data_file="/tmp/price_market.csv"

PRICE_CHANGE_PERCENTAGE_24H=4

KEYS=%i[id current_price high_24h low_24h price_change_percentage_24h price_change_percentage_7d_in_currency price_change_percentage_14d_in_currency price_change_percentage_30d_in_currency market_cap_change_percentage_24h]

def get(coins=%i[bitcoin bitcoin-cash ethereum chainlink litecoin ripple uniswap])
    url="https://api.coingecko.com/api/v3/coins/markets?vs_currency=php&ids=#{coins.join(',')}&order=market_cap_desc&per_page=100&page=1&sparkline=false&price_change_percentage=24h,7d,14d,30d,90d"
    res=""
    Thread.new(res){res=HTTParty.get(url)}.join
    jdata=JSON.parse(res.body, symbolize_names: true)
    [jdata.map{|coin| coin.values_at(*KEYS)}, jdata]
end

Thread.new{
  data=ArrayCSV.new(data_file, 'w')
  data.dataframe, jdata=get()
  data.dataframe=data.dataframe.sort_by{|e| e[PRICE_CHANGE_PERCENTAGE_24H]}
  data.dataframe.prepend KEYS.map{|k| 
    k.to_s
      .gsub(/change_percentage_/,'ch_')
      .gsub(/in_currency/,'php')
    }
  data.save
}.join

puts IO.popen("csview.rb #{data_file}", &:read)
