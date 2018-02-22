class FiltersController < ApplicationController
  include FiltersHelper

  ## handling api related filters
  MANDATORY_KEYWORDS = {"buy"=>"buy","rent"=>"rent","buying"=>"buy","kiraya"=>"rent"}
  PROPERTY_TYPE_MAP = {"flat"=>"apartment","apartments"=>"apartment","bungalow"=>"villa","mansion"=>"villa","flour"=>"floor","manjil"=>"floor","manjila"=>"floor","pent"=>"penthouse","terraced"=>"row_house","terris"=>"row_house","terrace"=>"row_house","row"=>"row_house","apartment" => "apartment", 'villa' => 'villa', 'floor' => 'floor', 'studio' => 'studio', 'duplex' => 'duplex', 'penthouse' => 'penthouse', 'row' => 'row_house'}
  #  skipping statement interpretation incase of to for 2 of 2BHK
  PRE_MAP_SET = {"bedroom"=>"room","bedrooms"=>"room","bhk"=>"room","kamara"=>"room","two"=>2,"one"=>1,"three"=>3,"teen"=>3,"four"=>4,"chaar"=>4,"five"=>5,"six"=>6,"seven"=>7,"eight"=>8,"nine"=>9,"ten"=>10,"purchase"=>"buy","onrent"=>"rent","plat"=>"plot","jameen"=>"plot","independent"=>"independent_house"}
  LANDMARK_KEYWORDS = ["near","opposite","opp","" ]

  def get_text
    puts "params present: #{params[:user_text]}"
    puts "request body #{request.body}"
    input_text = params[:user_text]
    original_text = params[:user_text]
    mandate_keyword_list,list,hall,room_count,property_type_found = normalize(input_text)
    result = {:message=>"",:data=>""}
    if mandate_keyword_list.empty?
      result[:message] = "hey, do you want to buy the property OR, rent out?"
    elsif property_type_found == false && room_count.to_i == 0
      result[:message] = "what type of property you are looking for ?"
    else
      if list.index("plot")
        apartment_type = "Plot"
      elsif hall == true || room_count.to_i > 1
        room_count =  room_count.to_i > 3 ? "3+" : room_count
        apartment_type = room_count.to_s + " BHK"
      end
      result[:data] = {:raw_input=>list,:apartment=>apartment_type,:service_type=>mandate_keyword_list.first}
    end
    result[:original_text] = original_text
    render :json=>result.to_json
    # identify the keywords and hit one method to check if it has mandatory filters
  end

  def normalize(str)
    input_array = str.gsub(/[,;.]/," ").split(" ").collect(&:downcase)
    keyword_list = []
    list = []
    hall = false
    property_type_found = false
    input_array.each.with_index do |str,index|
      input_array[index] =  PRE_MAP_SET["#{str}"] || input_array[index]
      keyword_list << MANDATORY_KEYWORDS["#{str}"] if MANDATORY_KEYWORDS["#{str}"].present?
      if PROPERTY_TYPE_MAP["#{str}"].present?
        input_array[index] = PROPERTY_TYPE_MAP["#{str}"]
        property_type_found = true
      end
      hall = true if (str.downcase == "bhk" || str.downcase =="hall")
    end
    unless property_type_found
      if input_array.index("house") && input_array("independent")
        input_array[input_array.index("house")] = "villa"
        property_type_found = true
      end
    end
    room_count = identify_room_count(input_array)
    # keyword_list = MANDATORY_KEYWORDS & input_array
    return [keyword_list,input_array,hall,room_count,property_type_found]
  end

  def landmark_lookup(input_string)
     # scan the input string and find the landmark using landmark_keyword and then hit the api to get the lat, lon then get the hit housing region api to identify the locality
  end



  private


  def identify_room_count(token_array)
  	room_index = token_array.index('room')
  	room_count = 0
  	# finding room numbers prior to 'room' keyword
  	if room_index
		for i in (0..room_index-1)
	   		if token_array[i].to_i >= 1
	   			room_count = token_array[i]
	   			break
	   		end
		end
  	end
	room_count
  end

end