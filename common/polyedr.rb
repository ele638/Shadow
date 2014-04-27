include Math

# Вектор (точка) в R3
class R3
  attr_reader :x, :y, :z
  def initialize(x, y, z)
    @x, @y, @z = x, y, z
  end
  # сумма векторов
  def +(other)
    R3.new(@x+other.x, @y+other.y, @z+other.z)
  end
  # разность векторов
  def -(other)
    R3.new(@x-other.x, @y-other.y, @z-other.z)
  end
  # умножение на число
  def *(k)
    R3.new(k*@x, k*@y, k*@z)
  end
  # поворот вокруг оси Oz
  def rz(fi) 
    R3.new(cos(fi)*@x-sin(fi)*@y, sin(fi)*@x+cos(fi)*@y, @z)
  end
  # поворот вокруг оси Oy
  def ry(fi) 
    R3.new(cos(fi)*@x+sin(fi)*@z, @y, -sin(fi)*@x+cos(fi)*@z)
  end
  # скалярное произведение 
  def dot(other) 
    @x*other.x+@y*other.y+@z*other.z
  end
  # векторное произведение
  def cross(other)
    R3.new(@y*other.z-@z*other.y, @z*other.x-@x*other.z, @x*other.y-@y*other.x)
  end
  
  def dist(other) #длина вектора (добавлено)
	Math.sqrt( (other.x-@x)**2 + (other.y-@y)**2 + (other.z-@z)**2)
  end
  
  def dist_proect(other) #длина проекции на плоскость Оху (добавлено)
	Math.sqrt( (other.x-@x)**2 + (other.y-@y)**2)
  end
  
  def angle(other)
	Math.acos(self.dist_proect(other)/self.dist(other))*180/Math::PI	#отношение прилежащего катета(длина проекции на плоскость Оху) к гипотенузе(длина вектора) (добавлено)
  end
end

# Ребро полиэдра
class Edge 
  # начало и конец ребра (точки в R3)
  attr_reader :beg, :fin
  def initialize(b, f)
    @beg, @fin = b, f
  end  
end

# Грань полиэдра
class Facet 
  # массив вершин
  attr_reader :vertexes, :edges
  def initialize(vertexes, edges, coef) #грань теперь задается 3я параметрами: вершины, грани ее образующие, коэффициент гомотетии(для удобства рассчетов) (обновлено)
    @vertexes = vertexes
	@edges = edges
	@coef=coef
  end
end

# Полиэдр
class Polyedr 
  # Массивы рёбер и граней
  attr_reader :edges, :facets 
  def initialize(file)
    # файл, задающий полиэдр
    File.open(file, 'r') do |f|
      # вспомогательный массив
      buf = f.readline.split
      # коэффициент гомотетии
      c = buf.shift.to_f
      #  углы Эйлера, определяющие вращение
      alpha, beta, gamma = buf.map{|x| x.to_f*PI/180.0}
      # количество вершин, граней и рёбер полиэдра
      nv, nf, ne  = f.readline.split.map(&:to_i)
      @vertexes, @edges, @facets = [], [], []
      # задание всех вершин полиэдра
      nv.times do
        x, y, z  = f.readline.split.map(&:to_f)
        @vertexes << R3.new(x,y,z).rz(alpha).ry(beta).rz(gamma)*c
      end
      nf.times do
		array_of_edges=[]
        # вспомогательный массив
        buf = f.readline.split
        # количество вершин
        size = buf.shift.to_i
        # массив вершин очередной грани 
        vertexes = buf.map{|x| @vertexes[x.to_i - 1]}
        # задание рёбер очередной грани
        (0...size).each{|n| @edges << Edge.new(vertexes[n-1],vertexes[n])} #заполняем массив всех ребер
		(0...size).each{|n| array_of_edges << Edge.new(vertexes[n-1],vertexes[n])} #заполняем массив ребер текущей грани (добавлено)
        # задание очередной грани полиэдра
        @facets << Facet.new(vertexes, array_of_edges,c) #создаем новую грань (обновлено)
      end
    end
  end
end