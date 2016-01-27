Rails.application.routes.draw do
  root 'channels#index'
  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }
  # get '/auth/:provider/callback', to: 'sessions#create'

  resources :channels

  resources :pins
  post "/pins" => "pins#create", :as => :create_pin
end
