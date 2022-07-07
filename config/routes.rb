Rails.application.routes.draw do
  
  # Users routes
  post 'api/user', to: 'users#authenticate', as: 'authentication_user'
  post 'api/user/add', to: 'users#add', as: 'add_user_path'
  put 'api/user', to: 'users#change_password', as: 'change_password'
  # Reservations routes
  get 'api/reservations', to: 'reservations#index', as: 'reservations_index'
  post 'api/reservations', to: 'reservations#add', as: 'reservations_add'
  delete 'api/reservations', to: 'reservations#destroy', as: 'reservations_destroy'
  # Provider routes
  get 'api/providers', to: 'providers#index', as: 'providers_index'
  post 'api/provider', to: 'providers#add', as: 'providers_add'
  delete 'api/provider', to: 'providers#destroy', as: 'providers_destroy'
  match '*unmatched', to: 'application#route_not_found', via: :all
end
