require 'swagger_helper'

RSpec.describe 'Passwords API', type: :request do
  before(:all) do
    @api = App.create(name: 'Front-End')
    @user = User.create(name: 'Victor',
                        email: 'victor.peralta.gomez@gmail.com',
                        password: '$2a$12$WpuCyzm/OwwA0FEGIRsHNuUt0fAGT0i44WVFM2vOkHKSUTk0BgbbG',
                        reset_password_token: 'd9cae7e946dd6333d5f5',
                        reset_password_sent_at: Time.now)
  end

  after(:all) do
    App.all.destroy_all
    User.all.destroy_all
  end
  path '/api/password/forgot' do
    post 'Send email for password recovery' do
      consumes 'application/json'
      security [BearerAuth: []]
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, format: :email, example: 'victor.peralta.gomez@gmail.com' }
        },
        required: %w[email]
      }

      response '200', 'Reset password email sent' do
        let(:Authorization) { "Bearer #{@api.token}" }
        let(:user) { { email: 'victor.peralta.gomez@gmail.com' } }
        run_test!
      end

      response '404', 'Email address not found. Please check and try again.' do
        let(:Authorization) { "Bearer #{@api.token}" }
        let(:user) { { email: 'victor@gmail.com' } }
        run_test!
      end

      response '422', 'Email not present' do
        let(:Authorization) { "Bearer #{@api.token}" }
        let(:user) { { name: 'Victor', email: '' } }
        run_test!
      end
    end
  end
  path '/api/password/reset' do
    post 'Change user password with token sent by email' do
      consumes 'application/json'
      security [BearerAuth: []]
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          new_password: { type: :string, example: '123456' },
          reset_password_token: { type: :string, example: 'd9cae7e946dd6333d5f5' }
        },
        required: %w[new_password reset_password_token]
      }

      response '200', 'ok' do
        let(:Authorization) { "Bearer #{@api.token}" }
        let(:user) { { new_password: '121212', reset_token: 'd9cae7e946dd6333d5f5' } }
        run_test!
      end

      response '404', 'Link not valid or expired. Try generating a new link.' do
        let(:Authorization) { "Bearer #{@api.token}" }
        let(:user) { { new_password: '121212', reset_token: 'd9cae7e946dd6333d5f5999' } }
        run_test!
      end

      # response '422', 'Link not valid or expired. Try generating a new link.' do
      #   let(:Authorization) { "Bearer #{@api.token}" }
      #   User.last.update({ reset_password_sent_at: Time.now - 10.hours })
      #   let(:user) { { new_password: '121212', reset_password_token: 'd9cae7e946dd6333d5f5' } }
      #   run_test!
      # end
    end
  end
end
