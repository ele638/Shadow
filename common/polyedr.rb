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
  attr_reader :vertexes
  def initialize(vertexes, edges) #объект класса Facet теперь помнит ребра, которыми он задан (обновлено)
    @edges = edges
    @vertexes = vertexes
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
        array=[] #вспомогательный массив ребер конкретной грани (добавлено)
        # вспомогательный массив
        buf = f.readline.split
        # количество вершин
        size = buf.shift.to_i
        # массив вершин очередной грани 
        vertexes = buf.map{|x| @vertexes[x.to_i - 1]}
        # задание рёбер очередной грани
        (0...size).each{|n| @edges << Edge.new(vertexes[n-1],vertexes[n])}
        (0...size).each{|n| array << Edge.new(vertexes[n-1],vertexes[n])} #запоминаем ребра грани (добавлено)
        # задание очередной грани полиэдра
        @facets << Facet.new(vertexes, array) #меняем инициализацию грани (добавлено)
      end
    end
  end
end
