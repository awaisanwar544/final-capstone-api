Rails.application.routes.draw do
  
  # Users routes
  post 'api/user', to: 'users#authenticate', as: 'authentication_user'
  post 'api/user/add', to: 'users#add', as: 'add_user_path'
  put 'api/user', to: 'users#change_password', as: 'change_password'
  # Password recovery
  post 'api/password/forgot', to: 'passwords#forgot'
  get 'api/password/validate_reset_token', to: 'passwords#validate_reset_token'
  post 'api/password/reset', to: 'passwords#reset'

  namespace :api, defaults: { format: :json } do
    # Provider routes
    resources :providers, only: [:index, :show, :create, :destroy]
    # Reservation routes
    resources :reservations, only: [:index, :create, :destroy]
  end
  match '*unmatched', to: 'application#route_not_found', via: :all
end
