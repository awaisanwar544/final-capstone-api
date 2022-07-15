require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  before(:all) do
    @api = App.create(name: 'Front-End')
    @user = User.create(name: 'Victor',
                        email: 'victor.peralta.gomez@gmail.com',
                        password: '$2a$12$WpuCyzm/OwwA0FEGIRsHNuUt0fAGT0i44WVFM2vOkHKSUTk0BgbbG')
  end

  after(:all) do
    App.all.destroy_all
    User.all.destroy_all
  end
  context 'API authentication' do
    it 'Get unauthorized Invalid token due to missing token' do
      post :authenticate, params: { email: 'victor.peralta.gomez@gmail.com', password: '121212' }
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to include('{"error:":"Invalid token"}')
    end

    it 'Get forbidden Unauthorized app due to invalid App token' do
      request.headers['Authorization'] = ''
      post :authenticate
      expect(response).to have_http_status(:forbidden)
      expect(response.body).to include('{"error:":"Unauthorized app"}')
    end
  end

  context 'User authentication' do
    it 'Get unauthorized User does not exist due to missing user information' do
      request.headers['Authorization'] = "Bearer #{@api.token}"
      post :authenticate
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to include('{"error:":"User does not exist"}')
    end

    it 'Get Ok User authenticated' do
      request.headers['Authorization'] = "Bearer #{@api.token}"
      post :authenticate, params: { email: 'victor.peralta.gomez@gmail.com', password: '121212' }
      expect(response).to have_http_status(:ok)
    end
  end

  context 'Adding user' do
    it 'Get unauthorized email already taken' do
      request.headers['Authorization'] = "Bearer #{@api.token}"
      post :add, params: { email: 'victor.peralta.gomez@gmail.com', password: '121212', name: 'Victor', admin: true }
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to include('{"error:":"email already taken"}')
    end

    it 'Get bad_request password too short' do
      request.headers['Authorization'] = "Bearer #{@api.token}"
      post :add, params: { email: 'victor.peraltagomez@gmail.com', password: '12121', name: 'Victor', admin: true }
      expect(response).to have_http_status(:bad_request)
      expect(response.body).to include('{"error:":"password too short"}')
    end

    it 'Get bad_request name can\'t be blank' do
      request.headers['Authorization'] = "Bearer #{@api.token}"
      post :add, params: { email: 'victor.peraltagomez@gmail.com', password: '121212', name: '', admin: true }
      expect(response).to have_http_status(:bad_request)
      expect(response.body).to include('{"error:":"can\'t be blank"}')
    end

    it 'Get bad_request email is invalid' do
      request.headers['Authorization'] = "Bearer #{@api.token}"
      post :add, params: { email: 'victor.peraltagomezgmail.com', password: '121212', name: 'Victor', admin: true }
      expect(response).to have_http_status(:bad_request)
      expect(response.body).to include('{"error:":"is invalid"}')
    end

    it 'Get Ok User added' do
      request.headers['Authorization'] = "Bearer #{@api.token}"
      post :add, params: { email: 'victor.peraltagomez@gmail.com', password: '121212', name: 'Victor', admin: true }
      expect(response).to have_http_status(:ok)
    end
  end
end
