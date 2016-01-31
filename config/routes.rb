Rails.application.routes.draw do

  root "welcome#index"

  # root 'static#index'
  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }
  resources :landings
  # get '/auth/:provider/callback', to: 'sessions#create'

  resources :channels
  resources :pins

  # post "/pins" => "pins#create", :as => :create_pin
  get ':action' => 'static#:action'
end
