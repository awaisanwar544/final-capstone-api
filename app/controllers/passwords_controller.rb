class PasswordsController < ApplicationController
  def forgot
    valid, error, status = UsersHelper::Validator.valid_app_token?(request.headers['Authorization'])
    unless valid
      # Invalid API token
      render json: { 'error:': error }, status: status
      return
    end

    if params[:email].blank?
      return render json: { error: 'Email not present' },
                    status: :unprocessable_entity
    end

    # check if email is present

    user = User.find_by_email(params[:email]) # if present find user by email

    if user.present?
      user.generate_password_token! # generate pass token
      # SEND EMAIL HERE
      NotifierMailer.send_password_reset_email(user).deliver_now
      render json: { message: 'Reset password email sent.' }, status: :ok
    else
      render json: { error: ['Email address not found. Please check and try again.'] }, status: :not_found
    end
  end

  def reset
    valid, error, status = UsersHelper::Validator.valid_app_token?(request.headers['Authorization'])
    return render json: { 'error:': error }, status: status unless valid

    reset_token = params[:reset_token].to_s
    return render json: { error: 'Token not present' }, status: :unauthorized if params[:reset_token].blank?

    user = User.find_by(reset_password_token: reset_token)
    return render json: { error: 'Password too short' }, status: :bad_request if params[:new_password].size < 6

    unless user.present? && user.password_token_valid?
      return render json: { error: ['Link not valid or expired. Try generating a new link.'] },
                    status: :not_found
    end

    if user.reset_password!(UsersHelper::Hash.encrypt(params[:new_password]))
      render json: { status: 'ok' }, status: :ok
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
