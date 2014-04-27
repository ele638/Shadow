#encoding: utf-8
#!/usr/bin/env ruby
require './polyedr'
require '../common/tk_drawer'
TkDrawer.create
%w(test0 test1 test1_1 test2 test2_1 test3 test3_1 ccc cube box king cow).each do |name|
#%w(test2 test2_1 test3 test3_1 ccc cube box king cow).each do |name| 
  puts '============================================================='
  puts "Начало работы с полиэдром '#{name}'"
  start_time = Time.now
  a=Polyedr.new("../data/#{name}.geom")
  a.draw
  puts a.sum
  puts "Изображение полиэдра '#{name}' заняло #{Time.now - start_time} сек."
  print 'Hit "Return" to continue -> '
  gets
end
