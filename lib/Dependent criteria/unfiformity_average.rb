require_relative 'useful_operations'
class UnfiformityAverage < UsefulOperations
  def subtract_average(array, power = 1)
    average = average(array)
    array.map { |el| (el - average)**power }
  end

  def dispersion(array)
    subtract_average(array, 2.0).sum / (array.length - 1)
  end

  def weighted_average_dispersion(x, y)
    n1 = x.length
    n2 = y.length
    dispersion_x = dispersion(x)
    dispersion_y = dispersion(y)
    ((n1 - 1) * dispersion_x + (n2 - 1) * dispersion_y) / (n1 + n2 - 2)
  end

  def statistic(x, y)
    avx = average(x)
    avy = average(y)
    n1 = x.length
    n2 = y.length
    s = weighted_average_dispersion(x, y)
    (avx - avy) / Math.sqrt(s / n1 + s / n2)
  end

  def student_quantile(x, y)
    n1 = x.length
    n2 = y.length
    v = n1 + n2 - 2
    Datum.student_quantile(v)
  end

  def conclusion(x, y)
    student_quantile = student_quantile(x, y)
    t = statistic(x, y)
    t > student_quantile ? 'Cередні двох вибірок не збігаються' : 'Середні двох вибірок збігаються'
  end
end