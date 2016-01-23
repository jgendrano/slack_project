Rails.application.routes.draw do
  root 'messages#index'
  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }
  # get '/auth/:provider/callback', to: 'sessions#create'
  resources :messages
  resources :pins
  post "/pins" => "pins#create", :as => :create_pin
end
