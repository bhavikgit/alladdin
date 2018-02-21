class FiltersController < ApplicationController
  include FiltersHelper

  ## handling api related filters
  VALID_KEYWORDS = ["buy","rent"]
  #  skipping statement interpretation incase of to for 2 of 2BHK
  PRE_MAP_SET = {"bedroom"=>"room","bhk"=>"room","kamara"=>"room","two"=>2,"one"=>1,"three"=>3,"teen"=>3,"purchase"=>"buy","onrent"=>"rent","plat"=>"plot","jameen"=>"plot","independent"=>"independent_house"}
  LANDMARK_KEYWORDS = ["near","opposite","opp","" ]
  def get_text
  	puts "params present: #{params[:user_text]}"
  	puts "request body #{request.body}"
    input_text = params[:user_text]
    keyword_list,list,hall = normalize(input_text)
    # identify the keywords and hit one method to check if it has mandatory filters
  end

  def normalize(str)
    input_array = str.gsub(/[,;.]/," ").split(" ")
    keyword_list = []
    hall = false
    input_array.each.with_index do |str,index|
      input_array[index] =  PRE_MAP_SET["#{str}"]
      hall = true if (str.downcase == "bhk" || str.downcase =="hall")
    end
    room_count = indentify_room_count(input_array)
    keyword_list = VALID_KEYWORDS & input_array
    return [keyword_list,input_array,hall]
  end

  def landmark_lookup(input_string)
     # scan the input string and find the landmark using landmark_keyword and then hit the api to get the lat, lon then get the hit housing region api to identify the locality
  end
end