Rails.application.routes.draw do
  
  # Users routes
  post 'api/user', to: 'users#authenticate', as: 'authentication_user'
  post 'api/user/add', to: 'users#add', as: 'add_user_path'
  put 'api/user', to: 'users#change_password', as: 'change_password'
  
  namespace :api, defaults: { format: :json } do
    # Provider routes
    resources :providers, only: [:index, :show, :create, :destroy]
    # Skill routes
    resources :skills, only: [:index, :create, :destroy]
    # Reservation routes
    resources :reservations, only: [:index, :show, :create, :destroy]
  end
  # match '*unmatched', to: 'application#route_not_found', via: :all
end
