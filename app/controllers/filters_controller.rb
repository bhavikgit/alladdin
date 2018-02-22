class FiltersController < ApplicationController
  include FiltersHelper

  ## handling api related filters
  STOP_WORDS_DICT = ["girl","girls","boys","boy","child","men","mens","baby","fuck","fucking","chutiya","ghar","wala","makan","makaan","i","we","they","them","a", "about", "above", "above", "across", "after", "afterwards", "again", "against", "all", "almost", "alone", "along", "already", "also","although","always","am","among", "amongst", "amoungst", "amount",  "an", "and", "another", "any","anyhow","anyone","anything","anyway", "anywhere", "are", "around", "as",  "at", "back","be","became", "because","become","becomes", "becoming", "been", "before", "beforehand", "behind", "being", "below", "beside", "besides", "between", "beyond", "bill", "both", "bottom","but", "by", "call", "can", "cannot", "cant", "co", "con", "could", "couldnt", "cry", "de", "describe", "detail", "do", "done", "down", "due", "during", "each", "eg", "eight", "either", "eleven","else", "elsewhere", "empty", "enough", "etc", "even", "ever", "every", "everyone", "everything", "everywhere", "except", "few", "fifteen", "fify", "fill", "find", "fire", "first", "five", "for", "former", "formerly", "forty", "found", "four", "from", "front", "full", "further", "get", "give", "go", "had", "has", "hasnt", "have", "he", "hence", "her", "here", "hereafter", "hereby", "herein", "hereupon", "hers", "herself", "him", "himself", "his", "how", "however", "hundred", "ie", "if", "in", "inc", "indeed", "interest", "into", "is", "it", "its", "itself", "keep", "last", "latter", "latterly", "least", "less", "ltd", "made", "many", "may", "me", "meanwhile", "might", "mill", "mine", "more", "moreover", "most", "mostly", "move", "much", "must", "my", "myself", "name", "namely", "neither", "never", "nevertheless", "next", "nine", "no", "nobody", "none", "noone", "nor", "not", "nothing", "now", "nowhere", "of", "off", "often", "on", "once", "one", "only", "onto", "or", "other", "others", "otherwise", "our", "ours", "ourselves", "out", "over", "own","part", "per", "perhaps", "please", "put", "rather", "re", "same", "see", "seem", "seemed", "seeming", "seems", "serious", "several", "she", "should", "show", "side", "since", "sincere", "six", "sixty", "so", "some", "somehow", "someone", "something", "sometime", "sometimes", "somewhere", "still", "such", "system", "take", "ten", "than", "that", "the", "their", "them", "themselves", "then", "thence", "there", "thereafter", "thereby", "therefore", "therein", "thereupon", "these", "they", "thickv", "thin", "third", "this", "those", "though", "three", "through", "throughout", "thru", "thus", "to", "together", "too", "top", "toward", "towards", "twelve", "twenty", "two", "un", "under", "until", "up", "upon", "us", "very", "via", "was", "we", "well", "were", "what", "whatever", "when", "whence", "whenever", "where", "whereafter", "whereas", "whereby", "wherein", "whereupon", "wherever", "whether", "which", "while", "whither", "who", "whoever", "whole", "whom", "whose", "why", "will", "with", "within", "without", "would", "yet", "you", "your", "yours", "yourself", "yourselves", "the","able", "about", "above", "according", "accordingly", "across", "actually", "after", "afterwards", "again", "against", "ain’t", "all", "allow", "allows", "almost", "alone", "along", "already", "also", "although", "always", "am", "among", "amongst", "an", "and", "another", "any", "anybody", "anyhow", "anyone", "anything", "anyway", "anyways", "anywhere", "apart", "appear", "appreciate", "appropriate", "are", "aren’t", "around", "as", "aside", "ask", "asking", "associated", "at", "available", "away", "awfully", "be", "became", "because", "become", "becomes", "becoming", "been", "before", "beforehand", "behind", "being", "believe", "below", "beside", "besides", "best", "better", "between", "beyond", "both", "brief", "but", "by", "c’mon", "c’s", "came", "can", "can’t", "cannot", "cant", "cause", "causes", "certain", "certainly", "changes", "clearly", "co", "com", "come", "comes", "concerning", "consequently", "consider", "considering", "contain", "containing", "contains", "corresponding", "could", "couldn’t", "course", "currently", "definitely", "described", "despite", "did", "didn’t", "different", "do", "does", "doesn’t", "doing", "don’t", "done", "down", "downwards", "during", "each", "edu", "eg", "eight", "either", "else", "elsewhere", "enough", "entirely", "especially", "et", "etc", "even", "ever", "every", "everybody", "everyone", "everything", "everywhere", "ex", "exactly", "example", "except", "far", "few", "fifth", "first", "five", "followed", "following", "follows", "for", "former", "formerly", "forth", "four", "from", "further", "furthermore", "get", "gets", "getting", "given", "gives", "go", "goes", "going", "gone", "got", "gotten", "greetings", "had", "hadn’t", "happens", "hardly", "has", "hasn’t", "have", "haven’t", "having", "he", "he’s", "hello", "help", "hence", "her", "here", "here’s", "hereafter", "hereby", "herein", "hereupon", "hers", "herself", "hi", "him", "himself", "his", "hither", "hopefully", "how", "howbeit", "however", "i’d", "i’ll", "i’m", "i’ve", "ie", "if", "ignored", "immediate", "in", "inasmuch", "inc", "indeed", "indicate", "indicated", "indicates", "inner", "insofar", "instead", "into", "inward", "is", "isn’t", "it", "it’d", "it’ll", "it’s", "its", "itself", "just", "keep", "keeps", "kept", "know", "knows", "known", "last", "lately", "later", "latter", "latterly", "least", "less", "lest", "let", "let’s", "like", "liked", "likely", "little", "look", "looking", "looks", "ltd", "mainly", "many", "may", "maybe", "me", "mean", "meanwhile", "merely", "might", "more", "moreover", "most", "mostly", "much", "must", "my", "myself", "name", "namely", "nd", "near", "nearly", "necessary", "need", "needs", "neither", "never", "nevertheless", "new", "next", "nine", "no", "nobody", "non", "none", "noone", "nor", "normally", "not", "nothing", "novel", "now", "nowhere", "obviously", "of", "off", "often", "oh", "ok", "okay", "old", "on", "once", "one", "ones", "only", "onto", "or", "other", "others", "otherwise", "ought", "our", "ours", "ourselves", "out", "outside", "over", "overall", "own", "particular", "particularly", "per", "perhaps", "placed", "please", "plus", "possible", "presumably", "probably", "provides", "que", "quite", "qv", "rather", "rd", "re", "really", "reasonably", "regarding", "regardless", "regards", "relatively", "respectively", "right", "said", "same", "saw", "say", "saying", "says", "second", "secondly", "see", "seeing", "seem", "seemed", "seeming", "seems", "seen", "self", "selves", "sensible", "sent", "serious", "seriously", "seven", "several", "shall", "she", "should", "shouldn’t", "since", "six", "so", "some", "somebody", "somehow", "someone", "something", "sometime", "sometimes", "somewhat", "somewhere", "soon", "sorry", "specified", "specify", "specifying", "still", "sub", "such", "sup", "sure", "t’s", "take", "taken", "tell", "tends", "th", "than", "thank", "thanks", "thanx", "that", "that’s", "thats", "the", "their", "theirs", "them", "themselves", "then", "thence", "there", "there’s", "thereafter", "thereby", "therefore", "therein", "theres", "thereupon", "these", "they", "they’d", "they’ll", "they’re", "they’ve", "think", "third", "this", "thorough", "thoroughly", "those", "though", "three", "through", "throughout", "thru", "thus", "to", "together", "too", "took", "toward", "towards", "tried", "tries", "truly", "try", "trying", "twice", "two", "un", "under", "unfortunately", "unless", "unlikely", "until", "unto", "up", "upon", "us", "use", "used", "useful", "uses", "using", "usually", "value", "various", "very", "via", "viz", "vs", "want", "wants", "was", "wasn’t", "way", "we", "we’d", "we’ll", "we’re", "we’ve", "welcome", "well", "went", "were", "weren’t", "what", "what’s", "whatever", "when", "whence", "whenever", "where", "where’s", "whereafter", "whereas", "whereby", "wherein", "whereupon", "wherever", "whether", "which", "while", "whither", "who", "who’s", "whoever", "whole", "whom", "whose", "why", "will", "willing", "wish", "with", "within", "without", "won’t", "wonder", "would", "would", "wouldn’t", "yes", "yet", "you", "you’d", "you’ll", "you’re", "you’ve", "your", "yours", "yourself", "yourselves", "zero"]
  MANDATORY_KEYWORDS = {"buy"=>"buy","buying"=>"buy","purchase"=>"buy","purchased"=>"buy","purchasing"=>"buy","kiraya"=>"rent","rent"=>"rent","hire"=>"rent","lease"=>"rent","rental"=>"rent"}
  PROPERTY_TYPE_MAP = {"hall"=>"hall","flat"=>"apartment","apartments"=>"apartment","bungalow"=>"villa","mansion"=>"villa","flour"=>"floor","manjil"=>"floor","manjila"=>"floor","pent"=>"penthouse","terraced"=>"row_house","terris"=>"row_house","terrace"=>"row_house","row"=>"row_house","apartment" => "apartment", 'villa' => 'villa', 'floor' => 'floor', 'studio' => 'studio', 'duplex' => 'duplex', 'penthouse' => 'penthouse', 'row' => 'row_house'}
  #  skipping statement interpretation incase of to for 2 of 2BHK
  PRE_MAP_SET = {"bedroom"=>"room","bedrooms"=>"room","bhk"=>"room","kamara"=>"room","two"=>2,"one"=>1,"three"=>3,"teen"=>3,"four"=>4,"chaar"=>4,"five"=>5,"six"=>6,"seven"=>7,"eight"=>8,"nine"=>9,"ten"=>10,"purchase"=>"buy","onrent"=>"rent","plat"=>"plot","jameen"=>"plot","independent"=>"independent_house"}
  LANDMARK_KEYWORDS = ["near","opposite","opp","" ]

  def get_text
    puts "params present: #{params[:user_text]}"
    puts "request body #{request.body}"
    input_text = params[:user_text]
    original_text = params[:user_text]
    mandate_keyword_list,list,hall,room_count,property_type_found,location_tokens = normalize(input_text)
    result = {:message=>"",:data=>""}
    if mandate_keyword_list.empty?
      result[:message] = "hey, do you want to buy the property OR, rent out?"
    elsif property_type_found == false && room_count.to_i == 0
      result[:message] = "what type of property you are looking for ?"
    else
      if list.index("plot")
        apartment_type = "Plot"
      elsif room_count.to_i == 1 && hall == false
        apartment_type = room_count.to_s + " RK"
      elsif hall == true || room_count.to_i >= 1
        room_count =  room_count.to_i > 3 ? "3+" : room_count
        result[:message] = "Please let us know, how many bedrooms are required?" if room_count.to_i == 0
        apartment_type = room_count.to_s + " BHK"
      end
      result[:data] = {:raw_input=>list,:apartment=>apartment_type,:service_type=>mandate_keyword_list.first}
    end
    result[:original_text] = original_text
    result[:location_tokens] = location_tokens
    render :json=>result.to_json
    # identify the keywords and hit one method to check if it has mandatory filters
  end

  def normalize(str)
    input_array = str.gsub(/[,;.]/," ").split(" ").collect(&:downcase)
    keyword_list = []
    list = []
    hall = false
    property_type_found = false
    identified_words = []
    input_array.each.with_index do |str,index|
      input_array[index] =  PRE_MAP_SET["#{str}"] || input_array[index]
      input_array[index] =  MANDATORY_KEYWORDS["#{str}"] if MANDATORY_KEYWORDS["#{str}"].present?  # testing to replace buying with buy
      keyword_list << MANDATORY_KEYWORDS["#{str}"] if MANDATORY_KEYWORDS["#{str}"].present?
      if PROPERTY_TYPE_MAP["#{str}"].present?
        input_array[index] = PROPERTY_TYPE_MAP["#{str}"]
        identified_words << PROPERTY_TYPE_MAP["#{str}"]
        property_type_found = true
      end
      identified_words << PRE_MAP_SET["#{str}"]
      identified_words << MANDATORY_KEYWORDS["#{str}"]
      hall = true if (str.downcase == "bhk" || str.downcase =="hall")
    end
    unless property_type_found
      if input_array.index("house") && input_array.index("independent")
        input_array[input_array.index("house")] = "villa"
        property_type_found = true
      end
    end
    location_tokens = input_array - identified_words - STOP_WORDS_DICT
    room_count = identify_room_count(input_array)
    # keyword_list = MANDATORY_KEYWORDS & input_array
    return [keyword_list,input_array,hall,room_count,property_type_found,location_tokens]
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