Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/url', to: 'url#new'
  get '*short_url', to: 'url#show'
  post '/url', to: 'url#create'
end
