#!/usr/bin/env ruby
# Id$ nonnax 2022-11-27 22:06:47
require 'rubytools/ansi_color'

class DF
  def diff(another, **params, &block)
    symbols=[-1, 0, 1].zip(['<', '=', '>']).to_h
    # symbols[-1]='<'
    # symbols[0] ='='
    # symbols[1] ='>'
    symbols.merge!([-1, 0, 1].zip(params[:symbols]).to_h)

    width=params.fetch(:width, 2)

    str_just=->(x,dir){
        [x,symbols[dir]].join(' ')
    }
    b = another.to_a
    v = to_a.map.with_index do |r, i|
      r.map.with_index do |v, j|
        bv = b[i][j]
        cond = block&.call(v, bv) || v <=> bv
        str_just[v, cond]
      end
    end
    DF.new { v }
  end
end
