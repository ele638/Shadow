require 'rspec'
require_relative '../shadow/polyedr'
require_relative 'support/matchers/to_be_close.rb'

describe "R3 angle: " do
	it "угол наклона вектора {0,0,1} относительно вертикальной оси равен 0" do
		expect(R3.new(0,0,0).angle(R3.new(0,0,1))).to be_close_to(0.0)
	end

	it "угол наклона вектора {1,1,0} относительно вертикальной оси равен 90" do
		expect(R3.new(0,0,0).angle(R3.new(1,1,0))).to be_close_to(90.0)
	end

	it "угол наклона вектора {1,0,1} относительно вертикальной оси равен 45" do
		expect(R3.new(0,0,0).angle(R3.new(1,0,1))).to be_close_to(45.0)
	end
end

describe "Класс Edge: " do
	context "метод is_center_good?: " do
		it "центр ребра {-1,-1,-1},{1,1,1} лежит в сфере" do
			expect(Edge.new(R3.new(-1,-1,-1),R3.new(1,1,1)).is_center_good?).to be_true
		end

		it "центр ребра {-1,-1,-1},{10,10,10} не лежит в сфере" do
			expect(Edge.new(R3.new(-1,-1,-1),R3.new(10,10,10)).is_center_good?).to be_false
		end
	end

	context "метод is_visible? : " do
		it "если ребро лежит на грани, то оно полностью видимое" do
	      s = Edge.new(R3.new(0.0,0.0,0.0), R3.new(1.0,1.0,0.0))
	      f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(2.0,0.0,0.0),
	                   R3.new(2.0,2.0,0.0),R3.new(0.0,2.0,0.0)])
	      s.shadow(f)
	      expect(s.is_visible?).to be_true
	    end

	    it "если ребро выше грани, то оно полностью видимое" do
	      s = Edge.new(R3.new(0.0,0.0,1.0), R3.new(1.0,1.0,1.0))
	      f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(2.0,0.0,0.0),
	                   R3.new(2.0,2.0,0.0),R3.new(0.0,2.0,0.0)])
	      s.shadow(f)
	      expect(s.is_visible?).to be_true
	    end

	    it "если ребро ниже грани, то оно не является полностью видимым" do
	      s = Edge.new(R3.new(0.0,0.0,-1.0), R3.new(1.0,1.0,-1.0))
	      f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(2.0,0.0,0.0),
	                   R3.new(2.0,2.0,0.0),R3.new(0.0,2.0,0.0)])
	      s.shadow(f)
	      expect(s.is_visible?).to be_false
	    end

	    it "если ребро частично видимое, то оно не является полностью видимым" do
	      s = Edge.new(R3.new(-5.0,-5.0,-1.0), R3.new(3.0,3.0,-1.0))
	      f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(2.0,0.0,0.0),
	                   R3.new(2.0,2.0,0.0),R3.new(0.0,2.0,0.0)])
	      s.shadow(f)
	      expect(s.is_visible?).to be_false
	    end
	end

	context "метод sum: " do
		it "длина вектора {3,4,0} равна 5" do
			s = Edge.new(R3.new(0.0,-1.0,0.0), R3.new(3.0,3.0,0.0))
			expect(s.sum).to eq 5.0
		end

		it "длина вектора {0,0,0} равна 5" do
			s = Edge.new(R3.new(0.0,-1.0,0.0), R3.new(0.0,-1.0,0.0))
			expect(s.sum).to eq(0.0)
		end

		it "длина вектора {5,5,0} равна sqrt(50)" do
			s = Edge.new(R3.new(0.0,-3.0,0.0), R3.new(5.0,2.0,0.0))
			expect(s.sum).to be_close_to(Math.sqrt(50))
		end

		it "длина вектора {20,0,15} равна 5" do
			s = Edge.new(R3.new(-10.0,-1.0,0.0), R3.new(10.0,-1.0,15.0))
			expect(s.sum).to eq(25.0)
		end
	end
end