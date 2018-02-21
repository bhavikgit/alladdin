module FiltersHelper
  ## module for processing the filters
  include FilterDictionaryHelper
  require "csv"


  def polygons_filter(text)
    localities_data, cities_data = [], []
    words = text.split(" ")
    CSV.foreach("tmp/polygons_data_dump.csv", headers: true) do |row|
      if words.include?(row[0])
        hash = {"name" => row[0], "uuid" => row[1], "city_uuid" => row[2]}
        (row[2].nil? or row[1] == row[2]) ? cities_data << hash : localities_data << hash
      end
    end
    return localities_data.uniq, cities_data.uniq
  end

end