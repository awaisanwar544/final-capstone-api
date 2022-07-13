require 'rails_helper'

RSpec.describe Api::ReservationsController, type: :controller do
  before(:all) do
    @api = App.create(name: 'Front-End')
    @user = User.create(name: 'Lucas',
                        email: 'ryxtor@outlook.com',
                        password: '$2a$12$WpuCyzm/OwwA0FEGIRsHNuUt0fAGT0i44WVFM2vOkHKSUTk0BgbbG')
    @provider = Provider.create(name: 'Victor', bio: 'A programmer from Mexico', cost: 10,
                                image: fixture_file_upload('victor.jpg', 'image/png'))
  end

  after(:all) do
    App.all.destroy_all
    User.all.destroy_all
    Reservation.all.destroy_all
    Provider.all.destroy_all
  end

  describe 'Creating a reservation' do
    it 'Create a reservation with User authorized' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      post :create, params: {
        provider_id: @provider.id,
        start_date: '2022-08-01',
        end_date: '2022-08-02',
        total_cost: 10
      }
      expect(response).to have_http_status(:created)
    end

    it 'Create a reservation with User Unauthorized ' do
      post :create, params: {
        provider_id: @provider.id,
        start_date: '2022-08-01',
        end_date: '2022-08-02',
        total_cost: 10
      }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'Create a reservation without Provider' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      post :create, params: {
        start_date: '2022-08-01',
        end_date: '2022-08-02',
        total_cost: 10
      }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'Create a reservation without Start Date' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      post :create, params: {
        provider_id: @provider.id,
        end_date: '2022-08-02',
        total_cost: 10
      }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'Create a reservation without End Date' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      post :create, params: {
        provider_id: @provider.id,
        start_date: '2022-08-01',
        total_cost: 10
      }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'Create a reservation without Total Cost' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      post :create, params: {
        provider_id: @provider.id,
        start_date: '2022-08-01',
        end_date: '2022-08-02'
      }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'Create a reservation with invalid Provider' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      post :create, params: {
        provider_id: 'invalid',
        start_date: '2022-08-01',
        end_date: '2022-08-02',
        total_cost: 10
      }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'Create a reservation with invalid Start Date' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      post :create, params: {
        provider_id: @provider.id,
        start_date: 'invalid',
        end_date: '2022-08-02',
        total_cost: 10
      }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'Create a reservation with invalid End Date' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      post :create, params: {
        provider_id: @provider.id,
        start_date: '2022-08-01',
        end_date: 'invalid',
        total_cost: 10
      }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'Create a reservation with invalid Total Cost' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      post :create, params: {
        provider_id: @provider.id,
        start_date: '2022-08-01',
        end_date: '2022-08-02',
        total_cost: 'invalid'
      }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'Create a reservation with more than a month of reservation' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      post :create, params: {
        provider_id: @provider.id,
        start_date: '2022-08-01',
        end_date: '2022-09-02',
        total_cost: 10
      }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'Getting a reservation' do
    it 'Get a reservation with User authorized' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      Reservation.create(provider_id: @provider.id,
                         user_id: @user.id,
                         start_date: '2022-08-01',
                         end_date: '2022-08-02',
                         total_cost: 10)
      get :index
      expect(response).to have_http_status(:ok)
    end

    it 'Get a reservation with User Unauthorized' do
      Reservation.create(provider_id: @provider.id,
                         user_id: @user.id,
                         start_date: '2022-08-01',
                         end_date: '2022-08-02',
                         total_cost: 10)
      get :index
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'Deleting a reservation' do
    it 'Delete a reservation with User authorized' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      reservation = Reservation.create(provider_id: @provider.id,
                                       user_id: @user.id,
                                       start_date: '2022-08-01',
                                       end_date: '2022-08-02',
                                       total_cost: 10)
      delete :destroy, params: { id: reservation.id }
      expect(response).to have_http_status(:ok)
    end

    it 'Delete a reservation with User Unauthorized' do
      reservation = Reservation.create(provider_id: @provider.id,
                                       user_id: @user.id,
                                       start_date: '2022-08-01',
                                       end_date: '2022-08-02',
                                       total_cost: 10)
      delete :destroy, params: { id: reservation.id }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'Delete a reservation with invalid id' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      delete :destroy, params: { id: 'invalid' }
      expect(response).to have_http_status(:bad_request)
    end
  end
end
