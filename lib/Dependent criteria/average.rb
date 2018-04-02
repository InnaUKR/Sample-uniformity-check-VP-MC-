class Dispersion
  attr_accessor :x, :y, :z, :avz, :n, :sqrt_subtracts, :subtracts , :sqrt_subtracts
  def initialize(x, y)
    @x = x
    @y = y
    @n = x.length
    @z = find_z
    @avz = z.sum / n
    @subtracts = subtract(z, avz)
    @sqrt_subtracts = sqrt(@subtracts)
  end

  def medium_square
    sqrt_subtracts.sum / (n - 1).to_f
  end

  def statistic
    avz * Math.sqrt(n) / medium_square
  end

  def find_z
    @x.zip(@y).map { |x, y| x - y }
  end

  def subtract(array, number)
    array.map { |el| el - number }
  end

  def sqrt(array)
    array.map { |el| el**2}
  end

  def conclusion
    statistic <= Datum.student_quantile
  end
end