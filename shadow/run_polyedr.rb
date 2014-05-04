#!/usr/bin/env ruby
require './polyedr'
require '../common/tk_drawer'
TkDrawer.create
%w(test1 test2 test3 test4).each do |name|
  puts '============================================================='
  puts "Начало работы с полиэдром '#{name}'"
  start_time = Time.now
  a=Polyedr.new("../data/#{name}.geom")
  a.draw
  puts a.magic
  puts "Изображение полиэдра '#{name}' заняло #{Time.now - start_time} сек."
  print 'Hit "Return" to continue -> '
  gets
end
