Rails.application.routes.draw do
  root to: 'guests#new'
  get '/thanks', to: 'pages#thanks', as: 'thank_you'
  get '/home', to: 'pages#home'

  resources :guests, only: [:new, :create, :destroy] do
    resources :invitations, only: [:create]
    resources :plus_one, only: [:new, :create], controller: 'plus_ones'
  end

  get '/confirm/:token', to: 'invitations#confirm', as: 'confirm'
  get '/expired-token', to: 'pages#expired_token', as: 'expired_token'

  namespace :admin do
    get '', to: 'admins#index'
    get '/search', to: 'admins#search', as: 'search'

    get '/login', to: 'sessions#new'
    post '/login', to: 'sessions#create'
    get 'logout', to: 'sessions#destroy'
  end

  scope '/admin' do
    post '/update-guests', to: 'invitations#bulk_create', as: 'admin_update_guests'
  end
end
