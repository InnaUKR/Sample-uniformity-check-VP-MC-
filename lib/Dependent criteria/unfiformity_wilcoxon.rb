class UnfiformityWilcoxonElement
  attr_reader :value, :label
  attr_accessor :index, :rank
  def initialize(value, label)
    @value = value
    @label = label
  end
end

class UnfiformityWilcoxon
  attr_reader :sample, :nx, :ny
  def initialize(x, y)
    @nx = x.length
    @ny = y.length
    @sample = x.map { |el| UnfiformityWilcoxonElement.new(el, :x) }
    @sample += y.map { |el| UnfiformityWilcoxonElement.new(el, :y) }
    index!
    rank!
  end

  def index!
    sample.sort_by(&:value).each_with_index { |el, i| el.index = i + 1 }
  end

  def rank!
    uniq_elements = sample.uniq
    uniq_elements.each do |uniq_element|
      bunch = sample.select { |el| el.value == uniq_element.value }
      if bunch.length == 1
        bunch.first.rank = uniq_element.index
      else
        bunch_rank = bunch.sum(&:index) / bunch.length.to_f
        bunch.each { |el| el.rank = bunch_rank }
      end
    end
  end

  def standardized_statistics
    (statistic - e) / Math.sqrt(d)
  end

  def statistic
    x = sample.select { |el| el.label == :x }
    x.sum(&:rank)
  end

  def d
    (nx * ny) / 12.0 * (nx + ny + 1)
  end

  def e
    nx / 2.0 * (nx + ny + 1)
  end

  def conclusion()
    normal_quantile = Datum.normal_quantile
    u = statistic.abs
    u > normal_quantile ? 'Функції розподілу зсунуті одна відносно іншої' : 'Зсуву у функціях розподілу немає'
  end

end