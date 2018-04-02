require_relative 'useful_operations'
class Average < UsefulOperations
  attr_accessor :x, :y, :z, :avz, :n, :sqrt_subtracts, :subtracts , :sqrt_subtracts
  def initialize(x, y)
    @x = x
    @y = y
    @n = x.length
    @z = subtract_arrays(x, y)
    @avz = average(z)
    @subtracts = subtract(z, avz)
    @sqrt_subtracts = sqrt(@subtracts)
  end

  def statistic
    avz * Math.sqrt(n) / medium_square(sqrt_subtracts)
  end

  def conclusion
    statistic <= Datum.student_quantile
  end
end