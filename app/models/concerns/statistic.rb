module Statistic
  THIRD_POWER = 3.0
  FOURTH_POWER = 4.0

  def median(param)
    datum = Datum.pluck(param)
    datum.sort!
    elements = datum.count
    center = elements / 2
    elements.even? ? (datum[center] + datum[center + 1]) / 2 : datum[center]
  end

  def dispersion(param)
    average_param = average(param)
    all.map{ |datum| (datum[param] - average_param)**2 }.sum / (count -1).to_f
  end

  def medium_square(param)
    Math.sqrt(dispersion(param))
  end

  def coefficient_offset(param, power)
    all.map{ |datum| (datum[param] - average(param))**power }.sum / (count * medium_square(param))**power
  end

  def asymmetry(param)
    n = count
    (Math.sqrt(n * (n -1))/(n - 2).to_f) * coefficient_offset(param, THIRD_POWER)
  end

  def excess(param)
    n = count
    (n**2 - 1.0) / ((n-2.0)*(n-3)) * coefficient_offset(param, FOURTH_POWER) - 3.0 + (6.0 / (n + 1))
  end

  def kontrekstsess(param)
    1.0 / excess(param)
  end

  def pirson(param)
    medium_square(param) / average(param)
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
    Math.sqrt((24.0 / n) * (1 - (225.0 / ((15 * n) + 124))))
  end

  def kontrekstsess_estimation(param)
    n = count
    excess = excess(param).abs
    (excess / (29 * n).to_f)**(1 / 2.0) * (excess**2 - 1)**(3 / 4.0)
  end

  def pirson_estimation(param)
    n = count
    pirson = pirson(param)
    pirson * Math.sqrt((1 + 2 * pirson**2) / (2 * n).to_f)
  end

  def confidence_interval(point_estimate, estimation)
    left_border = point_estimate - Datum.student_quantile * estimation
    right_border = point_estimate + Datum.student_quantile * estimation
    [left_border, right_border].map!{|el| el.to_f.round(4) }
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

  def kontrexcess_interval(param)
    confidence_interval(kontrekstsess(param), kontrekstsess_estimation(param))
  end

  def pirson_interval(param)
    confidence_interval(pirson(param), pirson_estimation(param))
  end
end