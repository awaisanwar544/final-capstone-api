class ApplicationController < ActionController::API
  def route_not_found
    render json: { error: 'Not Found' }
  end
end
