Classly::Application.routes.draw do
  
  resources :preferences 

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :courses

  root :to => "homepage#index"

end
