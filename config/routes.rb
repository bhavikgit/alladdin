Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'home#index'

  #get '/testing' => 'home#test'

  post '/post_text' => 'filter#get_text'

  # https://github.com/pndurette/gTTS
end
