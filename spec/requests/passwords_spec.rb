require 'rails_helper'

RSpec.describe PasswordsController, type: :controller do
  before(:all) do
    @api = App.create(name: 'Front-End')
    @user = User.create(name: 'John',
                        email: 'JohnJack0126@gmail.com',
                        password: '$2a$12$WpuCyzm/OwwA0FEGIRsHNuUt0fAGT0i44WVFM2vOkHKSUTk0BgbbG',
                        reset_password_token: 'd9cae7e946dd6333d5f5',
                        reset_password_sent_at: Time.now)
  end

  after(:all) do
    App.all.destroy_all
    User.all.destroy_all
  end
  context 'Forgot Password' do
    it 'Recover password of existent email' do
      request.headers['Authorization'] = "Bearer #{@api.token}"
      post :forgot, params: { email: 'JohnJack0126@gmail.com' }
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('{"message":"Reset password email sent."}')
    end

    it 'Recover password for wrong user email' do
      request.headers['Authorization'] = "Bearer #{@api.token}"
      post :forgot, params: { email: 'random_mail@gmail.com' }
      expect(response).to have_http_status(:not_found)
      expect(response.body).to include('{"error":["Email address not found. Please check and try again."]}')
    end

    it 'Recover password of blank email field' do
      request.headers['Authorization'] = "Bearer #{@api.token}"
      post :forgot, params: { email: '' }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include('{"error":"Email not present"}')
    end
  end
  context 'Reset Password' do
    it 'Recover password with valid token' do
      request.headers['Authorization'] = "Bearer #{@api.token}"
      post :reset, params: { reset_token: 'd9cae7e946dd6333d5f5', new_password: '7890123' }
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('{"status":"ok"}')
    end

    it 'Recover password with incorrect token' do
      request.headers['Authorization'] = "Bearer #{@api.token}"
      post :reset, params: { reset_token: 'd9cae7e946dd6333d5f59999', new_password: '7890123' }
      expect(response).to have_http_status(:not_found)
      expect(response.body).to include('{"error":["Link not valid or expired. Try generating a new link."]}')
    end

    it 'Recover password with expired token' do
      request.headers['Authorization'] = "Bearer #{@api.token}"
      User.last.update({ reset_password_sent_at: Time.now - 10.hours })
      post :reset, params: { reset_token: 'd9cae7e946dd6333d5f5', new_password: '7890123' }
      expect(response).to have_http_status(:not_found)
      expect(response.body).to include('{"error":["Link not valid or expired. Try generating a new link."]}')
    end
  end
end
