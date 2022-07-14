Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  
  # Users routes
  post 'api/user', to: 'users#authenticate', as: 'authentication_user'
  post 'api/user/add', to: 'users#add', as: 'add_user_path'
  put 'api/user', to: 'users#change_password', as: 'change_password'
  # Password recovery
  # Needed for creating the mail's link 
  get 'resetpassword', to: 'users#resetpassword', as: 'resetpassword'
  post 'api/password/forgot', to: 'passwords#forgot'
  post 'api/password/reset', to: 'passwords#reset'

  namespace :api, defaults: { format: :json } do
    # Provider routes
    resources :providers, only: [:index, :show, :create, :destroy]
    # Skill routes
    resources :skills, only: [:index, :create, :destroy]
    # Reservation routes
    resources :reservations, only: [:index, :create, :destroy]
  end
  match '*unmatched', to: 'application#route_not_found', via: :all
end
