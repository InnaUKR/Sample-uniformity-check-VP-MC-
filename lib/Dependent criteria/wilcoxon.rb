require_relative 'useful_operations'
class WilcoxonElement
  attr_accessor :rank, :index
  attr_reader :value, :abs_value, :a, :x, :y
  def initialize(x, y)
    @value = x - y
    @x = x
    @y = y
    @a = value > 0 ? 1 : 0
    @abs_value = value.abs
  end
end

class Wilcoxon < UsefulOperations
  attr_reader :z
  attr_accessor :elements_number_bunch
  def initialize(x, y)
    @z = []
    @elements_number_bunch = []
    x.zip(y).each do |x, y|
      z = x - y
      z.zero? ? next : @z << WilcoxonElement.new(x, y)
    end
    index!
    rank!
  end

  def index!
    z.sort_by{ |z| z.abs_value }.each_with_index{ |z, i| z.index = i+1}
  end

  def rank!
    uniq_elements = z.uniq(&:abs_value)
    uniq_elements.each do |uniq_element|
      bunch = z.select { |el| el.abs_value == uniq_element.abs_value }
      if bunch.length == 1
        bunch.first.rank = uniq_element.index
      else
        elements_number_bunch << bunch.length
        bunch_rank = bunch.sum(&:index) / bunch.length.to_f
        bunch.each { |el| el.rank = bunch_rank }
      end
    end
  end

  def multiple_a_rank
    z.map { |z| z.a * z.rank }
  end

  def statistic
    multiple_a_rank.sum
  end

  def bunch_sum_for_dispersion
    elements_number_bunch.sum { |a_j| a_j * (a_j - 1) * (a_j + 1) }
  end

  def dispersion
    n = z.length
    (n * (n + 1) * (2 * n + 1)- bunch_sum_for_dispersion / 2.0) / 24.0
  end

  def excess
    n = z.length
    n * (n + 1) / 4.0
  end

  def standard_statistic
    (statistic - excess) / dispersion**(1/2.0)
  end

  def conclusion
    normal_quantile = Datum.normal_quantile
    standard_statistic.abs > normal_quantile ? 'Функції розподілу зсунуті одна відносно іншої' : 'Зсуву у функціях розподілу немає'
  end
end