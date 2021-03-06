Rails.application.routes.draw do

  root "welcome#index"

  # root 'static#index'
  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }
  resources :landings
  # get '/auth/:provider/callback', to: 'sessions#create'

  resources :channels
  resources :messages
  resources :pins

  devise_scope :user do
    get '/signout', to: 'devise/sessions#destroy', as: :signout
  end


  post "/pins" => "pins#create"
  # get ':action' => 'static#:action'
end
