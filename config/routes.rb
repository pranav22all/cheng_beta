Rails.application.routes.draw do
  get 'password_resets/new'

  get 'password_resets/edit'

  get 'sessions/new'

  # get 'users/new'

  # get 'user/name:string'

  # get 'user/email:string'

  # get 'sessions/new'

  root 'current_pages#home'
  #NEED TO to or else heroku has not idea what to do 	

  get '/aboutus', to: 'current_pages#aboutus'
  get '/ourwork', to: 'current_pages#ourwork'
  get '/properties', to: 'current_pages#properties'
  get '/donations', to: 'current_pages#donations'
  get '/accepteddonations', to: 'current_pages#accepteddonations'
  get '/testimonials', to: 'current_pages#testimonials'
  get '/contactus', to: 'current_pages#contactus'
  #Falls under a different constructor (Since we are also calling a model on it)
  get '/signup', to: 'users#new'
  
  resources :users #Implements all RESTful resources for users model


  #Sessions isn't part of a model like users 
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new,:create,:edit,:update]
end
