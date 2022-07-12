class PasswordsController < ApplicationController
  def forgot
    valid, error, status = UsersHelper::Validator.valid_app_token?(request.headers['Authorization'])
    unless valid
      # Invalid API token
      render json: { 'error:': error }, status: status
      return
    end

    return render json: { error: 'Email not present' } if params[:email].blank? # check if email is present

    user = User.find_by_email(params[:email]) # if present find user by email

    if user.present?
      user.generate_password_token! # generate pass token
      # SEND EMAIL HERE
      render json: user.reset_password_token, status: :ok
    else
      render json: { error: ['Email address not found. Please check and try again.'] }, status: :not_found
    end
  end

  def validate_reset_token
    valid, error, status = UsersHelper::Validator.valid_app_token?(request.headers['Authorization'])
    unless valid
      # Invalid API token
      render json: { 'error:': error }, status: status
      return
    end

    reset_token = params[:reset_token].to_s

    return render json: { error: 'Token not present' } if params[:reset_token].blank?

    user = User.find_by(reset_password_token: reset_token)

    if user.present? && user.password_token_valid?
      render json: { status: 'ok' }, status: :ok
    else
      render json: { error: ['Link not valid or expired. Try generating a new link.'] }, status: :not_found
    end
  end

  def reset
    valid, error, status = UsersHelper::Validator.valid_app_token?(request.headers['Authorization'])
    unless valid
      # Invalid API token
      render json: { 'error:': error }, status: status
      return
    end

    reset_token = params[:reset_token].to_s

    return render json: { error: 'Token not present' } if params[:reset_token].blank?

    user = User.find_by(reset_password_token: reset_token)

    if user.present? && user.password_token_valid?
      if user.reset_password!(params[:new_password])
        render json: { status: 'ok' }, status: :ok
      else
        render json: { error: user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: ['Link not valid or expired. Try generating a new link.'] }, status: :not_found
    end
  end
end
