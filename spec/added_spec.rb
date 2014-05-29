require 'rspec'
require_relative '../shadow/polyedr'
require_relative 'support/matchers/to_be_close.rb'

describe Edge do
	context "метод length " do
		it "возвращает 1 для вектора {1,0,0}" do
			s = Edge.new(R3.new(0.0,0.0,-1.0), R3.new(1.0,0.0,-1.0))
			expect(s.length).to eq 1.0
		end
		
		it "возвращает 5 для вектора {3,4,0}" do
			s = Edge.new(R3.new(-1.0,2.0,-1.0), R3.new(2.0,6.0,-1.0))
			expect(s.length).to eq 5.0
		end
	end 
	context "метод is_visible?" do
		it "грань не затеняет ребра, принадлежащего этой же грани" do
	      s = Edge.new(R3.new(0.0,0.0,0.0), R3.new(1.0,1.0,0.0))
	      f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(2.0,0.0,0.0),
	                   R3.new(2.0,2.0,0.0),R3.new(0.0,2.0,0.0)])
	      s.shadow(f)
	      expect(s.is_visible?).to be_false
	    end

	    it "грань не затеняет ребра, расположенного выше грани" do
	      s = Edge.new(R3.new(0.0,0.0,1.0), R3.new(1.0,1.0,1.0))
	      f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(2.0,0.0,0.0),
	                   R3.new(2.0,2.0,0.0),R3.new(0.0,2.0,0.0)])
	      s.shadow(f)
	      expect(s.is_visible?).to be_false
	    end

	    it "грань полностью затеняет ребро, расположенное ниже грани" do
	      s = Edge.new(R3.new(0.0,0.0,-1.0), R3.new(1.0,1.0,-1.0))
	      f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(2.0,0.0,0.0),
	                   R3.new(2.0,2.0,0.0),R3.new(0.0,2.0,0.0)])
	      s.shadow(f)
	      expect(s.is_visible?).to be_false
	    end

	    it "на большом и длинном ребре, лежащем ниже грани, образуется ровно два просвета" do
	      s = Edge.new(R3.new(-5.0,-5.0,-1.0), R3.new(3.0,3.0,-1.0))
	      f=Facet.new([R3.new(0.0,0.0,0.0),R3.new(2.0,0.0,0.0),
	                   R3.new(2.0,2.0,0.0),R3.new(0.0,2.0,0.0)])
	      s.shadow(f)
	      expect(s.is_visible?).to be_true
	    end
	end
end
describe Facet do 
	context "метод perimetr " do
		it "возвращает 12 для квадрата со стороной 3" do
			edges=[]
			s=[R3.new(0.0,0.0,0.0),R3.new(3.0,0.0,0.0),R3.new(3.0,3.0,0.0),R3.new(0.0,3.0,0.0)]
			(0...s.size).each {|n| edges << Edge.new(s[n-1],s[n])}
			f=Facet.new(s,edges)
			expect(f.perimetr).to eq 12.0
		end

		it "возвращает 20 для квадрата со стороной 5" do
			edges=[]
			s=[R3.new(-2.0,0.0,0.0),R3.new(3.0,0.0,0.0),R3.new(3.0,5.0,0.0),R3.new(0-2.0,5.0,0.0)]
			(0...s.size).each {|n| edges << Edge.new(s[n-1],s[n])}
			f=Facet.new(s,edges)
			expect(f.perimetr).to eq 20.0
		end
	end
end