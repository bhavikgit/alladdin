module FiltersHelper
  ## module for processing the filters
  include FilterDictionaryHelper
  require "csv"

  INDEX_NAME = "polygon_index"
  INDEX_TYPE = "polygons"

  ## not used anymore
  def polygons_filter(text)
    localities_data, cities_data = [], []
    CSV.foreach("tmp/polygons_data_dump.csv", headers: true) do |row|
      if row[0].present? and (text.downcase).include?(row[0].downcase)
        hash = {"name" => row[0], "uuid" => row[1], "city_uuid" => row[2]}
        (row[2].nil? or row[1] == row[2]) ? cities_data << hash : localities_data << hash
      end
    end
    return localities_data.uniq, cities_data.uniq
  end

  def get_relevant_polygons(words)
    localities_data, cities_data = [], []

    query = get_es_query(words)
    poly_results = get_poly_results_from_es(query)
    
    hits = poly_results["hits"]["hits"]
    if hits.empty?
      return localities_data, cities_data
    else
      hits.each do |hit|
        hit = hit["_source"]
        required_data = hit.slice("name", "uuid", "city_uuid")
       (hit["city_uuid"].nil? or hit["uuid"] == hit["city_uuid"]) ? cities_data << required_data : localities_data << required_data
      end
      return localities_data, cities_data 
    end
  end

  def get_es_query(words)
    text = words.join(" ")
    {
      "query" => {
        "match" => {
          "name" => {
            "query" => text,
            "fuzziness" => "auto"
          }
        }
      }
    }.to_json
  end

  def get_poly_results_from_es(query)
    client = ExternalApiHelper.get_client
    return ExternalApiHelper.get_results_from_es(client, INDEX_NAME, INDEX_TYPE, query)
  end

  def get_city_uuid(words)
    localities_data, cities_data = get_relevant_polygons(words)
    locality_city_uuids = localities_data.map {|locality| locality["city_uuid"]}
    city_uuids = cities_data.map {|city| city["uuid"]}
    locality_city_uuids.max_by { |i| locality_city_uuids.count(i) } || city_uuids.max_by { |i| city_uuids.count(i) } 
  end

  def apartment_type_filter(apartment_type)
    apartment_type_hash = {}
    apartment_type_hash["housing"] = FilterDictionaryHelper::HOUSING_BHK_FILTERS[apartment_type]
    apartment_type_hash["makaan"] = FilterDictionaryHelper::MAKAAN_BHK_FILTERS[apartment_type]
    return apartment_type_hash
  end

  def property_type_filter(property_type)
    property_type_hash = {}
    property_type_hash["housing"] = FilterDictionaryHelper::HOUSING_PROPERTY_TYPE[property_type]
    property_type_hash["makaan"] = FilterDictionaryHelper::MAKAAN_PROPERTY_TYPE[property_type]
    return property_type_hash
  end

end