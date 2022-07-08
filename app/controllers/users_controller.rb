class UsersController < ApplicationController
  def authenticate
    token = app_token
    name = JwtHelper::JsonWebToken.decode(token)
    unless App.where(name:, token:)
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

  def add
    token = app_token
    name = JwtHelper::JsonWebToken.decode(token)
    unless App.where(name:, token:)
      render json: { 'error:': 'Unauthorized app' }, status: :forbidden
      return
    end
    return unless valid_user?

    user = User.new(email: params[:email],
                    admin: params[:admin] || false,
                    name: params[:name] || '',
                    password: UsersHelper::Hash.encrypt(params[:password]))
    if user.valid?
      user.save
      render json: user, status: :ok
    else
      render json: { 'error:': user.errors.first.message }, status: :bad_request
    end
  end

  private

  def valid_user?
    user = User.find_by_email(params[:email])
    if user
      render json: { 'error:': 'email already taken' }, status: :unauthorized
      return false
    end
    if params[:password].size < 6
      render json: { 'error:': 'password too short' }, status: :bad_request
      return false
    end
    true
  end

  def app_token
    header = request.headers['Authorization']
    header.split.last
  end
end
