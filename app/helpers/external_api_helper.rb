module ExternalApiHelper 

  def self.post_api_call(action, url, post_args, caller=nil, form_data_request=true)
    uri = URI.parse(url)
    if form_data_request
      response = Net::HTTP.post_form(uri, post_args)
    else
      http = Net::HTTP.new(uri.host, uri.port)
      if action == 'post'
        request = Net::HTTP::Post.new(uri.request_uri)
      elsif action == 'put'
        request = Net::HTTP::Put.new(uri.request_uri)
      elsif action == 'delete'
        request = Net::HTTP::Delete.new(uri.request_uri)  
      elsif action == 'get'
        request = Net::HTTP::Get.new(uri.request_uri)    
      end
      request.add_field('Content-Type', 'application/json')
      request.body = post_args
      begin
      response = http.request(request)
      rescue
        raise "Error from url: #{url}"
      end
    end

    code  = (response.code).to_i
    return code, response.body
  end

end