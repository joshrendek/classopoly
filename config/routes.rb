Classly::Application.routes.draw do
  

  get '/preferences', :to => "preferences#index"
  post '/preferences/update', :to => "preferences#update"

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :user_courses do
    collection do
      get 'generate_course_list'
    end
  end

  resources :courses

  root :to => "homepage#index"

end
