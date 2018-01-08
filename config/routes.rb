Rails.application.routes.draw do
  root to: 'guests#new'
  get '/thanks', to: 'pages#thanks', as: 'thank_you'
  get '/home', to: 'pages#home'

  resources :guests, only: [:new, :create]
end
