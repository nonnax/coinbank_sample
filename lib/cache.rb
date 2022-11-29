#!/usr/bin/env ruby
# frozen_string_literal: true

# Id$ nonnax 2022-11-28 20:07:52
require 'file/filer'

def cache(**params, &block)
  timestamp = Time.now.strftime('%c')
  data_file = params[:data_file]
  diffview_method = params[:fn]
  if File.age(data_file) < params.fetch(:timeout, 60)
    ft, v = Filer.load(MarshalFile.new(data_file))
    if v.values.size > 1
      diffview_method.call(*v.values.last(2))
    else
      puts v.values.last
    end
  else
    ft, v = Filer.load(MarshalFile.new(data_file)) { {} }
    ft.write v.merge(timestamp => block.call)
  end
end
