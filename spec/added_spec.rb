require 'rspec'
require_relative '../shadow/polyedr'
require_relative 'support/matchers/to_be_close.rb'

describe "Added methods: " do
	context "visible? method: " do
		it "грань не затеняет ребра, принадлежащего этой же грани" do
	      s = Edge.new(R3.new(0.0,0.0,0.0), R3.new(1.0,1.0,0.0))
	      f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(2.0,0.0,0.0),
	                   R3.new(2.0,2.0,0.0),R3.new(0.0,2.0,0.0)])
	      s.shadow(f)
	      expect(s.visible?).to be_true
	    end

	    it "грань не затеняет ребра, расположенного выше грани" do
	      s = Edge.new(R3.new(0.0,0.0,1.0), R3.new(1.0,1.0,1.0))
	      f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(2.0,0.0,0.0),
	                   R3.new(2.0,2.0,0.0),R3.new(0.0,2.0,0.0)])
	      s.shadow(f)
	      expect(s.visible?).to be_true
	    end

	    it "грань полностью затеняет ребро, расположенное ниже грани" do
	      s = Edge.new(R3.new(0.0,0.0,-1.0), R3.new(1.0,1.0,-1.0))
	      f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(2.0,0.0,0.0),
	                   R3.new(2.0,2.0,0.0),R3.new(0.0,2.0,0.0)])
	      s.shadow(f)
	      expect(s.visible?).to be_false
	    end

	    it "на большом и длинном ребре, лежащем ниже грани, образуется ровно два просвета" do
	      s = Edge.new(R3.new(-5.0,-5.0,-1.0), R3.new(3.0,3.0,-1.0))
	      f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(2.0,0.0,0.0),
	                   R3.new(2.0,2.0,0.0),R3.new(0.0,2.0,0.0)])
	      s.shadow(f)
	      expect(s.visible?).to be_false
		end
	end
	context "center_good? method: " do
		it "Центр в точке (0.5; 0.0) не удовлетворяет условию" do
			s = Edge.new(R3.new(0.0,0.0,-1.0), R3.new(1.0,0.0,-1.0))
			expect(s.center_good?).to be_false
		end

		it "Центр в точке (2.0; 0.0) удовлетворяет условию" do
			s = Edge.new(R3.new(1.0,0.0,-1.0), R3.new(3.0,0.0,-1.0))
			expect(s.center_good?).to be_true
		end

		it "Центр в точке (2.1000; 0.0) удовлетворяет условию" do
			s = Edge.new(R3.new(1.0,1000.0,-1.0), R3.new(3.0,1000.0,-1.0))
			expect(s.center_good?).to be_true
		end
	end
	context "proection method: " do
		it "Длина проекции вектора {1,0,0} равна еденице" do
			s = Edge.new(R3.new(0.0,0.0,-1.0), R3.new(1.0,0.0,-1.0))
			expect(s.proection).to be_close_to(s.r3(1.0))
		end

		it "Длина проекции вектора {-3,4,0} равна пяти" do
			s = Edge.new(R3.new(4.0,0.0,-1.0), R3.new(1.0,4.0,-1.0))
			expect(s.proection).to be_close_to(s.r3(5.0))
		end

		it "Длина проекции вектора {0,0,51} равна нулю" do
			s = Edge.new(R3.new(0.0,0.0,-1.0), R3.new(0.0,0.0,50.0))
			expect(s.proection).to be_close_to(s.r3(0.0))
		end
	end
end

describe "polyedr: " do
	context "func method: " do
		it do
			a=Polyedr.new("../data/test1.geom")
			expect(a.func).to eq(15.0)
		end
		it do
			a=Polyedr.new("../data/test2.geom")
			expect(a.func).to eq(5.0)
		end
	end
end