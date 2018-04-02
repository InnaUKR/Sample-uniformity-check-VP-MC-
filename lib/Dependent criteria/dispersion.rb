require_relative 'useful_operations'
class Dispersion < UsefulOperations
  attr_accessor :x, :y, :av_x, :av_y, :subtracts_x, :subtracts_y, :sqrt_subtracts_x, :sqrt_subtracts_y, :medium_square_x, :medium_square_y
  def initialize(x, y)
    @x = x
    @y = y
    @av_x = average(x)
    @av_y = average(y)
    @subtracts_x = subtract(x, av_x)
    @subtracts_y = subtract(y, av_y)
    @sqrt_subtracts_x = sqrt(subtracts_x)
    @sqrt_subtracts_y = sqrt(subtracts_y)
  end

  def statistic
    @medium_square_x = medium_square(sqrt_subtracts_x)
    @medium_square_y = medium_square(sqrt_subtracts_y)
    medium_square_x >= medium_square_y ? medium_square_x / medium_square_y : medium_square_y / medium_square_x
  end

  def fisher_quantile_params
    if medium_square_x >= medium_square_y
      v1 = x.length - 1
      v2 = y.length - 1
    else
      v1 = y.length - 1
      v2 = x.length - 1
    end
    [v1, v2]
  end

  def fisher_quantile
    v1, v2 = fisher_quantile_params
    Datum.fisher_quantile(v1, v2)
  end

  def conclusion
    statistic <= fisher_quantile
  end
end