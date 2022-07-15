require 'swagger_helper'

RSpec.describe 'Users API', type: :request do
  before(:all) do
    @api = App.create(name: 'Front-End')
    @user = User.create(name: 'Victor',
                        email: 'victorperaltagomez@gmail.com',
                        password: '$2a$12$nmvjGxvGgdReXAH/z3HW0OzJdon3ImCjX7CTyRyZXZIBc3vBIuwwK')
  end

  after(:all) do
    App.all.destroy_all
    User.all.destroy_all
  end

  path '/api/user/add' do
    post 'Sign up a new user with API token' do
      consumes 'application/json'
      security [BearerAuth: []]
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, format: :email, example: 'victorperaltagomez@gmail.com' },
          password: { type: :string, example: 'holahola' },
          name: { type: :string, example: 'Victor Peralta' },
          admin: { type: :boolean }
        },
        required: %w[email name password]
      }

      response '200', 'user signed up' do
        let(:Authorization) { "Bearer #{@api.token}" }
        let(:user) { { name: 'Victor', email: 'victor.peralta.gomez@gmail.com', password: 'holahola', admin: true } }
        run_test!
      end

      response '401', 'email already taken' do
        let(:Authorization) { "Bearer #{@api.token}" }
        let(:user) { { name: 'Victor', email: 'victorperaltagomez@gmail.com', password: 'holahola', admin: true } }
        run_test!
      end

      response '400', 'Invalid Parameter' do
        let(:Authorization) { "Bearer #{@api.token}" }
        let(:user) { { name: 'Victor', email: 'victor.peralta.gomez@gmail.com', password: '1212', admin: true } }
        run_test!
      end
    end
  end

  path '/api/user' do
    post 'Log in user with API token' do
      consumes 'application/json'
      security [BearerAuth: []]
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, format: :email, example: 'victor.peralta.gomez@gmail.com' },
          password: { type: :string, example: 'holahola' }
        },
        required: %w[email password]
      }
      response '200', 'user signed in' do
        let(:Authorization) { "Bearer #{@api.token}" }
        let(:user) { { email: 'victorperaltagomez@gmail.com', password: 'holahola' } }
        run_test!
      end

      response '401', 'unauthorized user' do
        let(:Authorization) { "Bearer #{@api.token}" }
        let(:user) { { email: 'victorperaltagomez@gmail.com', password: 'ho12lahola' } }
        run_test!
      end
    end
  end
end
