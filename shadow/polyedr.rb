require_relative '../common/polyedr'

# Одномерный отрезок
class Segment
  # начало и конец отрезка (числа)
  attr_reader :beg, :fin
  def initialize(b, f)
    @beg, @fin = b, f
  end
  # отрезок вырожден?
  def degenerate? 
    @beg >= @fin
  end
  # пересечение с отрезком
  def intersect!(other) 
    @beg = other.beg if other.beg > @beg
    @fin = other.fin if other.fin < @fin
    self
  end
  # разность отрезков
  def subtraction(other)
    [Segment.new(@beg, @fin < other.beg ? @fin : other.beg),
     Segment.new(@beg > other.fin ? @beg : other.fin, @fin)]
  end
end

# Ребро полиэдра
class Edge 
  # Начало и конец стандартного одномерного отрезка
  SBEG = 0.0; SFIN = 1.0
  # начало и конец ребра (точки в R3), список "просветов"
  attr_reader :beg, :fin, :gaps
  def initialize(b, f)
    @beg, @fin, @gaps = b, f, [Segment.new(SBEG, SFIN)]
  end  
  # учёт тени от одной грани
  def shadow(facet)
    return if facet.vertical?
    # нахождение одномерной тени на ребре
    shade = Segment.new(SBEG, SFIN)
    facet.vertexes.zip(facet.v_normals) do |arr|
     shade.intersect!(intersect_edge_with_normal(arr[0], arr[1]))
      return if shade.degenerate? 
    end
    shade.intersect!(intersect_edge_with_normal(facet.vertexes[0], facet.h_normal))
    return if shade.degenerate?    
    # преобразование списка "просветов", если тень невырождена
    @gaps = @gaps.map do |s|
      s.subtraction(shade)
    end.flatten.delete_if(&:degenerate?)
  end
  # преобразование одномерных координат в трёхмерные
  def r3(t)
    @beg*(SFIN-t) + @fin*t
  end

  def length #метод вычисления длины проекции ребра (добавлено)
    return Math.sqrt( (@fin.x-@beg.x)**2 + (@fin.y-@beg.y)**2 )
  end

  def is_visible? #метод проверки на частичную видимость (добавлено)
    return false if @gaps.size==0 #если невидимое
    return false if @gaps.size==1 and @gaps[0].beg==SBEG and @gaps[0].fin==SFIN #если полностью видимое
    return true
  end

  private
  # пересечение ребра с полупространством, задаваемым точкой (a)
  # на плоскости и вектором внешней нормали (n) к ней
  def intersect_edge_with_normal(a, n)
    f0, f1 = n.dot(@beg - a), n.dot(@fin - a)
    return Segment.new(SFIN, SBEG) if f0 >= 0.0 and f1 >= 0.0
    return Segment.new(SBEG, SFIN) if f0 < 0.0 and f1 < 0.0
    x = - f0 / (f1 - f0)
    f0 < 0.0 ? Segment.new(SBEG, x) : Segment.new(x, SFIN)
  end
end    

# Грань полиэдра
class Facet 
  # "вертикальна" ли грань?
  def vertical?
    h_normal.dot(Polyedr::V) == 0.0
  end
  # нормаль к "горизонтальному" полупространству
  def h_normal
    n = (@vertexes[1]-@vertexes[0]).cross(@vertexes[2]-@vertexes[0])
    n.dot(Polyedr::V) < 0.0 ? n*(-1.0) : n
  end
  # нормали к "вертикальным" полупространствам, причём k-я из них
  # является нормалью к гране, которая содержит ребро, соединяющее
  # вершины с индексами k-1 и k
  def v_normals
    (0...@vertexes.size).map do |k|
      n = (@vertexes[k] - @vertexes[k-1]).cross(Polyedr::V)
      n.dot(@vertexes[k-1] - center) < 0.0 ? n*(-1.0) : n
    end
  end

  def perimetr #метод вычисления периметра (добавлено)
    per=0
    @edges.each{|e| per+=e.length }
    return per
  end

  def is_good? #метод проверки грани на центр и частичную видимость
    return false if self.center.x<=1 and self.center.x>=-1 and self.center.y<=1 and self.center.y>=-1
    @edges.each{|e| return false if !e.is_visible?}
    return true
  end

  # центр грани
  def center
    @vertexes.inject(R3.new(0.0,0.0,0.0)){|s,v| s+v}*(1.0/@vertexes.size)
  end
end

# Полиэдр
class Polyedr 
  # вектор проектирования
  V = R3.new(0.0,0.0,1.0)

  def func(f)
    return f.is_good? ? f.perimetr : 0.0
  end

  def draw
    sum=0
    TkDrawer.clean
    edges.each do |e|
      facets.each{|f| e.shadow(f)}
      sum+=func(f)
      e.gaps.each{|s| TkDrawer.draw_line(e.r3(s.beg), e.r3(s.fin))}
    end
    return sum
  end
end
