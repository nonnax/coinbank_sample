#!/usr/bin/env ruby
# Id$ nonnax 2021-11-19 10:39:32 +0800
require 'rover-df'
require 'numeric_ext'
require 'array_table'
require 'arraycsv'
require 'tempfile'

root="/home/seti/ruby-sandbox/github/coinbank/"
data_file=root+"market_#{Time.now.yday}.csv"
bank_file=root="/home/seti/ruby-sandbox/github/coinbank/bank1.csv"

IO.popen("today.rb", &:read) unless File.exists?(data_file) && (Time.now - File.mtime(data_file) < 60)

df=Rover.parse_csv(File.read(data_file), header_converters: [:symbol])
df_bank=Rover.parse_csv(File.read(bank_file), header_converters: [:symbol])

df[:ch_lowhigh]=(df[:high_24h]/df[:low_24h]-1)*100

data=df.left_join(df_bank)

data[:new_amount]=    data[:current_price]*data[:hold]
data[:old_amount]=    data[:price]*data[:hold]
data[:amount_change]= data[:new_amount]-data[:old_amount]
data[:price_change]=  data[:current_price]-data[:price]
data[:position]=  data[:price]==0 ? (data[:current_price]/data[:price]-1)*100 : 0
# p data
KEYS=%i[id current_price high_24h low_24h price price_change position hold new_amount old_amount amount_change]
d=[]
data[KEYS].to_a.map do |h|
  d << [h[:id], *h.values_at(*%i[current_price high_24h low_24h price price_change position hold new_amount old_amount amount_change]).map(&:commify)]
end

tab=ArrayCSV.new('table.csv', 'w')
tab.dataframe=d.sort_by{|a| a[0].to_s }
tab.dataframe.prepend KEYS
tab.save
puts IO.popen("csv_table table.csv", &:read)
  
puts 

dfout = df[%i[id current_price high_24h low_24h ch_lowhigh price_ch_24h price_ch_7d_php price_ch_30d_php market_cap_ch_24h]]
outf='market_rover.csv'
File.write(outf, dfout.to_csv)
puts IO.popen("csv_table #{outf}", &:read)
