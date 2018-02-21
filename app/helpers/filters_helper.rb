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

  def apartment_type_filter(apartment_type)
    apartment_type_hash = {}
    apartment_type_hash["housing"] = FilterDictionaryHelper::HOUSING_BHK_FILTERS[apartment_type]
    apartment_type_hash["makaan"] = FilterDictionaryHelper::MAKKAN_BHK_FILTERS[apartment_type]
    return apartment_type_hash
  end

  def property_type_filter(property_type)
    property_type_hash = {}
    property_type_hash["housing"] = FilterDictionaryHelper::HOUSING_PROPERTY_TYPE[property_type]
    property_type_hash["makaan"] = FilterDictionaryHelper::MAKKAN_PROPERTY_TYPE[property_type]
    return property_type_hash
  end

end