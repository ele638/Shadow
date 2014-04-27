require 'rspec'
require './polyedr'
require '../common/tk_drawer'
EPS = 1.0e-1
describe "Figures" do 
  it "test_0" do
    a = Polyedr.new("../data/test0.geom")
    a.draw
    puts a.sum
    a.sum.should be_within(EPS).of(1600.0)
  end
   
  it "test_1" do
    a = Polyedr.new("../data/test1.geom")
    a.draw
    puts a.sum
    a.sum.should be_within(EPS).of(0.0)
  end
   
 it "test_2" do
    a = Polyedr.new("../data/test2.geom")
    a.draw
    puts a.sum
    a.sum.should be_within(EPS).of(1600.0)
 end
 
  it "test_3" do
    a = Polyedr.new("../data/test3.geom")
    a.draw
    a.sum.should be_within(EPS).of(0.0)
 end


end
