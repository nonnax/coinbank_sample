#!/usr/bin/env ruby
# Id$ nonnax 2022-11-28 20:07:52
require 'file/filer'

def cache(handler: TextFile, data_file: '/tmp/price_market.csv',  bank_file: File.expand_path('~/.bank/bank1.csv'), timeout: 60, &block)
  ft =
  Filer
  .new(handler.new(data_file))
  .tap{|f| f.read{f.write nil} } # file must exist to be tested for age

  if File.age(data_file) < timeout
    puts ft.read
  else
    ft.write [block.call, ft.read].join("\n")
  end
end
