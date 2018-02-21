class FiltersController < ApplicationController
  include FiltersHelper

  ## handling api related filters

  def get_text
  	puts "params present: #{params[:user_text]}"
  	puts "request body #{request.body}"
  end
end