class UsersController < ApplicationController
  def authenticate
    header = request.headers['Authorization']
    token = header.split.last
    app_name = JwtHelper::JsonWebToken.decode(token)
    unless App.where(name: app_name)
      render json: { 'error:': 'Unauthorized app' }, status: :forbidden
      return
    end
    user = User.find_by_email(params[:email])
    unless user
      render json: { 'error:': 'User does no exist' }, status: :unauthorized
      return
    end
    if UsersHelper::Hash.valid?(params[:password], user.password)
      render json: user, status: :ok
    else
      render json: { 'error:': 'Invalid Password' }, status: :unauthorized
    end
  rescue StandardError => e
    render json: { 'error:': e }, status: :bad_request
  end
end
