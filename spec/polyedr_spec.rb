require 'rspec'
require '../shadow/polyedr'
EPS = 1.0e-1
describe "Figures" do 
  it "test_1" do
    a = Polyedr.new("../data/test1.geom")
    a.magic.round(1).should be_within(EPS).of(717.3)
  end
   
 it "test_2" do
    a = Polyedr.new("../data/test2.geom")
    a.magic.round(1).should be_within(EPS).of(400.0)
 end
 
  it "test_3" do
    a = Polyedr.new("../data/test3.geom")
    a.magic.round(1).should be_within(EPS).of(0.0)
 end
 
   it "test_4" do
    a = Polyedr.new("../data/test4.geom")
    a.magic.round(1).should be_within(EPS).of(0.0)
 end
end
