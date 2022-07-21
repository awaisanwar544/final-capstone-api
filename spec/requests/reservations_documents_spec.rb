require 'swagger_helper'

RSpec.describe 'Reservations API', type: :request do
  before(:all) do
    @api = App.create(name: 'Front-End')
    @user = User.create(id: 1, name: 'Lucas',
                        email: 'ryxtor@outlook.com',
                        password: '$2a$12$WpuCyzm/OwwA0FEGIRsHNuUt0fAGT0i44WVFM2vOkHKSUTk0BgbbG')
    @p = Provider.create(id: 1, name: 'Victor', bio: 'A programmer from Mexico', cost: 10,
                         image: fixture_file_upload('victor.jpg', 'image/png'))
    @p.save
    @reservation = Reservation.create(id: 1, user_id: 1, provider_id: 1,
                                      start_date: '2022-08-08', end_date: '2022-08-14', total_cost: 10)
  end

  after(:all) do
    App.all.destroy_all
    Reservation.all.destroy_all
    User.all.destroy_all
    Provider.all.destroy_all
  end

  path '/api/reservations' do
    post 'Create a reservation with User token' do
      consumes 'application/json'
      security [BearerAuth: []]
      parameter name: :reservation, in: :body, schema: {
        type: :object,
        properties: {
          provider_id: { type: :integer, example: 1 },
          start_date: { type: :date, example: '2022-08-08' },
          end_date: { type: :date, example: '2022-08-12' },
          total_cost: { type: :decimal, example: '10' }
        },
        required: %w[provider_id start_date end_date total_cost]
      }

      response '201', 'Reservation created' do
        produces 'application/json'
        let(:Authorization) { "Bearer #{@user.token}" }
        let(:reservation) { { provider_id: @p.id, start_date: '2022-08-08', end_date: '2022-08-12', total_cost: '10' } }
        run_test!
      end

      response '403', 'Unauthorized user' do
        let(:Authorization) { 'Bearer invalid' }
        let(:reservation) { { provider_id: @p.id, start_date: '2022-08-08', end_date: '2022-08-12', total_cost: '10' } }
        run_test!
      end

      response '422', 'Invalid request' do
        let(:Authorization) { "Bearer #{@user.token}" }
        let(:reservation) { { provider_id: @p.id, start_date: '2022-08-08', end_date: '2022-08-12' } }
        run_test!
      end
    end
  end

  path '/api/reservations/{id}' do
    delete 'Delete a reservation with User token' do
      security [BearerAuth: []]
      parameter name: :id, in: :path, type: :integer, required: true,
                example: 1, description: 'The reservation\'s ID'
      response '200', 'Reservation deleted' do
        produces 'application/json'
        let(:Authorization) { "Bearer #{@user.token}" }
        let(:id) { @reservation.id }
        run_test!
      end

      response '403', 'Unauthorized user' do
        let(:Authorization) { 'Bearer invalid' }
        let(:id) { @reservation.id }
        run_test!
      end

      response '400', 'Reservation not found' do
        let(:Authorization) { "Bearer #{@user.token}" }
        let(:id) { 0 }
        run_test!
      end
    end
  end

  path '/api/reservations' do
    get 'List all reservations with User token' do
      security [BearerAuth: []]
      response '200', 'Get Reservation list' do
        produces 'application/json'
        let(:Authorization) { "Bearer #{@user.token}" }
        run_test!
      end

      response '403', 'Unauthorized user' do
        let(:Authorization) { 'Bearer invalid' }
        run_test!
      end
    end
  end
end
