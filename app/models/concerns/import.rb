module Import
  require 'csv'
  class Data_structure
    attr_accessor :x_rank, :y_rank, :x_index, :y_index
    attr_reader :x, :y
    def initialize(x, y)
      @x = x
      @y = y
    end
  end
  def x_index!(arr)
    arr.sort_by{|el| el.x}.each_with_index{|el, i| el.x_index = i+1}
  end
  def y_index!(arr)
    arr.sort_by{|el| el.y}.each_with_index{|el, i| el.y_index = i+1}
  end
  def x_rank!(arr)
    uniq_x = arr.uniq(&:x)
    uniq_x.each do |uniq_x|
      bunch = arr.select{|el| el.x == uniq_x.x}
      if bunch.length == 1
        bunch.first.x_rank = uniq_x.x_index
      else
        bunch_rank = bunch.sum(&:x_index) / bunch.length.to_f
        bunch.each{|el| el.x_rank = bunch_rank}
      end
    end
  end

  def y_rank!(arr)
    uniq_y = arr.uniq(&:y)
    uniq_y.each do |uniq_y|
      bunch = arr.select{|el| el.y == uniq_y.y}
      if bunch.length == 1
        bunch.first.y_rank = uniq_y.y_index
      else
        bunch_rank = bunch.sum(&:y_index) / bunch.length.to_f
        bunch.each{|el| el.y_rank = bunch_rank}
      end
    end
  end

  def fill_gaps!(arr)
    x_index!(arr)
    x_rank!(arr)
    y_index!(arr)
    y_rank!(arr)
  end

  def import!(file)
    data_array = []
    Datum.delete_all

    CSV.foreach(file.path, headers: false) do |row|
      datum_array = row.first.split("\s")
      data_array << Data_structure.new(datum_array.first.to_f, datum_array.last.to_f)
    end

=begin
    data_array = [
        Data_structure.new(3, 5),
        Data_structure.new(5, 9),
        Data_structure.new(7, 5),
        Data_structure.new(7, 8),
        Data_structure.new(10, 13),
        Data_structure.new(11, 10),
        Data_structure.new(12, 15)
    ]
=end
    fill_gaps!(data_array)
    data_array.sort_by!(&:x_rank).each{|el| Datum.create(x: el.x, y: el.y, x_rank: el.x_rank, y_rank: el.y_rank)}
  end
end

