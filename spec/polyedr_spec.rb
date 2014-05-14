require 'rspec'
require '../shadow/polyedr'
EPS = 1.0e-1
describe "Figures" do 
  it "test_1" do
    a = Polyedr.new("../data/test1.geom")
    a.sum.should be_within(EPS).of(400.0)
  end
   
 it "test_2" do
    a = Polyedr.new("../data/test2.geom")
    a.sum.should be_within(EPS).of(0.0)
 end
 
  it "test_3" do
    a = Polyedr.new("../data/test3.geom")
    a.sum.should be_within(EPS).of(800.0)
 end
 
   it "test_4" do
    a = Polyedr.new("../data/test4.geom")
    a.sum.should be_within(EPS).of(0.0)
 end
end

describe "Angle" do
  it "вектор {0,0,1} находится под углом к плоскости Oxy большим, чем PI/7 (90 градусов)" do
    s = Edge.new(R3.new(0.0,0.0,0.0), R3.new(0.0,0.0,1.0))
    expect(s.beg.angle(s.fin)).to eq 90.0
    expect(s.beg.angle(s.fin)<=180/7).to be_false
  end

  it "вектор {1,1,0} находится под углом к плоскости Oxy меньшим, чем PI/7 (0 градусов)" do
    s = Edge.new(R3.new(0.0,0.0,0.0), R3.new(1.0,1.0,0.0))
    expect(s.beg.angle(s.fin)).to eq 0.0
    expect(s.beg.angle(s.fin)<=180/7).to be_true
  end

  it "вектор {3,0,3} находится под углом к плоскости Oxy меньшим, чем PI/7 (45 градусов)" do
    s = Edge.new(R3.new(0.0,0.0,0.0), R3.new(3.0,0.0,3.0))
    expect(s.beg.angle(s.fin)).to eq 45.0
    expect(s.beg.angle(s.fin)<=180/7).to be_false
  end
end

describe "Sphere" do
 it "test1" do
      f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(2.0,0.0,0.0),
                   R3.new(2.0,2.0,0.0),R3.new(0.0,2.0,0.0)])
      expect((f.center.x**2)+(f.center.y**2)+(f.center.z**2)<4).to be_true
    end

    it "test2" do
      f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(3.0,0.0,0.0),
                   R3.new(0.0,3.0,0.0)])
     expect((f.center.x**2)+(f.center.y**2)+(f.center.z**2)<4).to be_true
    end

    it "test3" do
      f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(30.0,0.0,0.0),
                   R3.new(0.0,30.0,0.0)])
     expect((f.center.x**2)+(f.center.y**2)+(f.center.z**2)<4).to be_false
    end
end
