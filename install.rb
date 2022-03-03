#!/usr/bin/env ruby
# Id$ nonnax 2022-03-03 18:47:37 +0800
require 'fileutils'
root=File.expand_path('~/.bank')
bank_file='bank1.csv'
FileUtils.mkdir_p root unless Dir.exists?(root)
FileUtils.cp bank_file, root unless File.exists?(File.join(root, bank_file))
