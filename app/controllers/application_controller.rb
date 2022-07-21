class ApplicationController < ActionController::API
  def home
    redirect_to rswag_ui_path
  end
end
