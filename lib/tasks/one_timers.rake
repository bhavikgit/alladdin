namespace :one_timers do
  require "csv"

  URL = "http://localhost:9200"

	desc "create index with mapping on our local system"
	task :create_index_with_mapping => :environment do
    url = "#{URL}/polygon_index"
    post_args = {
      "settings" => {
        "number_of_shards" => 1
        },
      "mappings" => {
        "polygons" => {
          "properties" => {
            "name" => {
              "type" => "text"
            },
            "uuid" => {
              "type" => "text"
            },
            "city_uuid" => {
              "type" => "text"
            }
          }
        }
      }
    }.to_json
    ExternalApiHelper.post_api_call('put', url, post_args, nil, false)
	end

  desc "add data in our index"
  task :add_data_in_index => :environment do
    url = "#{URL}/polygon_index/polygons"
    count = 1
    CSV.foreach("tmp/polygons_data_dump.csv", headers: true) do |row|
      #if count >= 2 break
      data = {
        "name" => row[0],
        "uuid" => row[1],
        "city_uuid" => row[2]
      }.to_json
      ExternalApiHelper.post_api_call('post', url, data, nil, false)
      count += 1
    end
  end

  desc "add data in our index"
  task :add_data_in_index_json => :environment do
    count = 0
    url = "#{URL}/polygon_index/polygons/_bulk"
    csv = CSV.read("tmp/polygons_data_dump.csv", headers: true)
    csv.each_slice(1000) do |batch|
      data = ""
      batch.each do |row|
        data  +=  "{'index':{}}" + "\n"
        data_hash = {
        "name": row[0],
        "uuid": row[1],
        "city_uuid": row[2]
        }
        data += "#{data_hash}" + "\n"
      end
      ExternalApiHelper.post_api_call('post', url, data.to_json, nil, false)
      count += 1
      puts "Batch completed: #{count}"
    end
  end

  desc "delete index"
  task :delete_index => :environment do
    url = "#{URL}/polygon_index"
    ExternalApiHelper.post_api_call('delete', url, {}.to_json, nil, false)
  end

end