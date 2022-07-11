Rails.application.routes.draw do
  
  # Users routes
  post 'api/user', to: 'users#authenticate', as: 'authentication_user'
  post 'api/user/add', to: 'users#add', as: 'add_user_path'
  put 'api/user', to: 'users#change_password', as: 'change_password'
  # Reservations routes
  get 'api/reservations', to: 'reservations#index', as: 'reservations_index'
  post 'api/reservations', to: 'reservations#add', as: 'reservations_add'
  delete 'api/reservations', to: 'reservations#destroy', as: 'reservations_destroy'
  # # Provider routes
  namespace :api, defaults: { format: :json } do
    resources :providers, only: [:index, :show, :create, :destroy]
    resources :skills, only: [:index, :create, :destroy]
  end
  # match '*unmatched', to: 'application#route_not_found', via: :all
end
