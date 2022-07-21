class NotifierMailer < ApplicationMailer
  default from: 'no-reply-bookdev@outlook.com'

  # send a signup email to the user, pass in the user object that   contains the user's email address
  def send_signup_email(user)
    @user = user
    mail(to: @user.email,
         subject: 'Thanks for signing up for our amazing app')
  end

  def send_password_reset_email(user)
    @user = user
    mail(to: @user.email,
         subject: 'Password reset instructions')
  end
end
