#!/usr/bin/env ruby
require './polyedr'
require '../common/tk_drawer'
TkDrawer.create
%w(ccc cube box king cow).each do |name|
  puts '============================================================='
  puts "Начало работы с полиэдром '#{name}'"
  start_time = Time.now
  a=Polyedr.new("../data/#{name}.geom") #получаем доступ к полиэдру, загоняя его в переменную a
  a.draw #рисуем его
  puts a.func #выводим искомое число.
  puts "Изображение полиэдра '#{name}' заняло #{Time.now - start_time} сек."
  print 'Hit "Return" to continue -> '
  gets
end
