class ApplicationController < ActionController::API

  # before_action :authenticate_request

  # private

  # def authenticate_request
  #   header = request.headers['Authorization']
  #   header = header.split.last if header
  #   decoded = JwtHelper::JsonWebToken.decode(header)
  #   p decoded
  #   @current_user = User.find(decoded)
  # end
end
