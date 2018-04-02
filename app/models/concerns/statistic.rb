module Statistic
  THIRD_POWER = 3.0
  FOURTH_POWER = 4.0

  def dispersion(param)
    average_param = average(param)
    all.map{|datum| (datum[param] - average_param)**2}.sum / count
  end

  def medium_square(param)
    Math.sqrt(dispersion(param)).to_f.round(Datum::ROUND_NUMBER)
  end

  def coefficient_offset(param, power)
    all.map{|datum| (datum[param] - average(param))**power}.sum / (count * (medium_square(param))**power).to_f.round(Datum::ROUND_NUMBER)
  end

  def asymmetry(param)
    n = count
    ((Math.sqrt(n * (n -1))/(n - 2).to_f) * coefficient_offset(param, THIRD_POWER)).to_f.round(Datum::ROUND_NUMBER)
  end

  def excess(param)
    n = count
    ((n**2 - 1.0) / ((n-2.0)*(n-3)) * coefficient_offset(param, FOURTH_POWER) - 3.0 + (6.0 / (n + 1))).to_f.round(Datum::ROUND_NUMBER)
  end

  def confidence_interval(point_estimate, estimation)
    left_border = point_estimate - Datum::STUDENT_QUANTILE * estimation
    right_border = point_estimate + Datum::STUDENT_QUANTILE * estimation
    [left_border.to_f.round(Datum::ROUND_NUMBER), right_border.to_f.round(Datum::ROUND_NUMBER)]
  end

  def average_estimation(param)
    medium_square(param) / Math.sqrt(count)
  end

  def medium_square_estimation(param)
    medium_square(param) / Math.sqrt(2.0 * count)
  end

  def asymmetry_estimation
    n = count
    Math.sqrt((6.0 * (n -2.0))/((n + 1.0) * (n + 3.0)))
  end

  def excess_estimation
    n = count
    Math.sqrt((24.0 / n) * (1 - (225.0 / ((15 * n) + 124 ))))
  end

  def average_interval(param)
    confidence_interval(average(param), average_estimation(param))
  end

  def medium_square_interval(param)
    confidence_interval(medium_square(param), medium_square_estimation(param))
  end

  def asymmetry_interval(param)
    confidence_interval(asymmetry(param), asymmetry_estimation)
  end

  def excess_interval(param)
    confidence_interval(excess(param), excess_estimation)
  end
end