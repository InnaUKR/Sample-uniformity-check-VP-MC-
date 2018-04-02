class UsefulOperations
  def average(array)
    array.sum / array.length
  end

  def subtract(array, number)
    array.map { |el| el - number }
  end

  def sqrt(array)
    array.map { |el| el**2 }
  end

  def subtract_arrays(array1, array2)
    array1.zip(array2).map { |x, y| x - y }
  end

  def medium_square(array)
    array.sum / (array.length - 1).to_f
  end
end