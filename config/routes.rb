Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'home#index'

  get '/testing' => 'home#test'
  post '/post_text' => 'filter#get_text'

  get '/test/api' => 'dummy#fetch_results'

  get '/testing' => 'home#test'
  get '/design' => 'home#design'
end
