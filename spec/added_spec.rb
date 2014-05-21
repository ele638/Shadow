require 'rspec'
require_relative '../shadow/polyedr'
require_relative 'support/matchers/to_be_close.rb'

describe "R3 class: " do 
	context "is_point_good? method: " do
		it "точка (1,2,3) лежит на расстоянии 1 от прямой x=2" do
			a=R3.new(1.0, 2.0, 3.0)
			expect(a.is_point_good?).to be_false
		end
		it "точка (1.5,2,3) лежит на расстоянии 0.5 от прямой x=2" do
			a=R3.new(1.5, 2.0, 3.0)
			expect(a.is_point_good?).to be_true
		end
		it "точка (2,2,3) лежит на расстоянии 0 от прямой x=2" do
			a=R3.new(2.0, 2.0, 3.0)
			expect(a.is_point_good?).to be_true
		end
		it "точка (2.5,2,3) лежит на расстоянии 0.5 от прямой x=2" do
			a=R3.new(2.5, 2.0, 3.0)
			expect(a.is_point_good?).to be_true
		end
		it "точка (3,2,3) лежит на расстоянии 1 от прямой x=2" do
			a=R3.new(3.0, 2.0, 3.0)
			expect(a.is_point_good?).to be_false
		end
	end
end
describe "Edge class: " do
	context "center method: " do
		it "возвращает точку (4,6,8) для отрезка {0,0,0},{4,6,8}" do 
			a=Edge.new(R3.new(0.0,0.0,0.0), R3.new(4.0,6.0,8.0))
			expect(a.center.x).to eq 2.0
			expect(a.center.y).to eq 3.0
			expect(a.center.z).to eq 4.0
		end
		it "возвращает точку (4,6,8) для отрезка {2,3,4},{6,8,12}" do 
			a=Edge.new(R3.new(2.0,3.0,4.0), R3.new(6.0,9.0,12.0))
			expect(a.center.x).to eq 4.0
			expect(a.center.y).to eq 6.0
			expect(a.center.z).to eq 8.0
		end
	end

	context "length method: " do
		it "возвращает 5 для вектора {3,4,0}" do
			a=Edge.new(R3.new(0.0,0.0,0.0), R3.new(3.0,4.0,0.0))
			expect(a.length).to eq 5.0
		end
		it "возвращает sqrt(50) для вектора {3,4,5}" do
			a=Edge.new(R3.new(1.0,2.0,3.0), R3.new(4.0,6.0,8.0))
			expect(a.length).to eq Math.sqrt(50)
		end
	end
end
describe "Polyedr class: " do
	context "func method: " do
		it "Коэффициент гомотетии не влияет на расчет. №1" do
			a=Polyedr.new("./data/test1.geom")
			expect(a.func).to eq(3.0)
		end
		it "Коэффициент гомотетии не влияет на расчет. №2" do
			a=Polyedr.new("./data/test2.geom")
			expect(a.func).to eq(3.0)
		end
	end
end