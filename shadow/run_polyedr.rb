#!/usr/bin/env ruby
require './polyedr'
require '../common/tk_drawer'
TkDrawer.create
%w(ccc cube box king cow).each do |name|
  puts '============================================================='
  puts "Начало работы с полиэдром '#{name}'"
  start_time = Time.now
  p = Polyedr.new("../data/#{name}.geom")
  p.draw
  puts p.calculate_something()
  puts "Изображение полиэдра '#{name}' заняло #{Time.now - start_time} сек."
  print 'Hit "Return" to continue -> '
  gets
end
