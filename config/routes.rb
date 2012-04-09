Classly::Application.routes.draw do
  get "/faq", :to => "static_page#faq"

  get "/about", :to => "static_page#about"

  get "instructor_vote/create"

  resources :wall_messages

  get '/friends', :to => "facebook#friends"
  get '/friends/invite/:uid', :to => "facebook#invite", :as => "invite_friend"
  get '/preferences', :to => "preferences#index"
  post '/preferences/update', :to => "preferences#update"

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :user_courses do
    collection do
      get 'generate_course_list'
    end
  end

  resources :instructors do 
    resources :instructor_votes
    resources :wall_messages
  end

  resources :courses do 
    resources :wall_messages
  end

  root :to => "homepage#index"

end
