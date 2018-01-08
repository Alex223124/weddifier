Rails.application.routes.draw do
  root to: 'guests#new'
  get '/thanks', to: 'pages#thanks', as: 'thank_you'
  get '/home', to: 'pages#home'

  resources :guests, only: [:new, :create]

  namespace :admin do
    get '', to: 'admins#index'
    get '/login', to: 'sessions#new'
    post '/login', to: 'sessions#create'
    get 'logout', to: 'sessions#destroy'
  end
end
