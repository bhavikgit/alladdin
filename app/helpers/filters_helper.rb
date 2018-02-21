module FiltersHelper
  ## module for processing the filters
  include FilterDictionaryHelper
  require "csv"


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

  def get_relevant_polygons(text)
    url = "http://es.burrow.io/polygon_index/polygons/_search"
    query = get_es_query(text)
    localities_data, cities_data = [], []
    ## need to test this once
    status_code, results = ExternalApiHelper.post_api_call('get', url, query, nil, false)
    if status_code != 200
      return localities_data, cities_data
    else
      results = JSON.parse(results)
      hits = results["hits"]["hits"]
      localities_data, cities_data = [], []
      hits.each do |hit|
        hit = hit["_source"]
        required_data = hit.slice("name", "uuid", "city_uuid")
       (hit["city_uuid"].nil? or hit["uuid"] == hit["city_uuid"]) ? cities_data << required_data : localities_data << required_data
      end
      return localities_data, cities_data 
    end
  end

  def get_es_query(text)
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