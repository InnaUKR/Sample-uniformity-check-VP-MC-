module Import
  require 'csv'

  def import!(file)
    Datum.delete_all

    CSV.foreach(file.path, headers: false) do |row|
      elements = row.first.split("\s")
      Datum.create(x: elements.first.to_f, y: elements.last.to_f)
    end
  end
end

