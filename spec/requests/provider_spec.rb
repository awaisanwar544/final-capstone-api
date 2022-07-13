require 'rails_helper'

RSpec.describe Api::ProvidersController, type: :controller do
  before(:all) do
    @admin = User.create(name: 'Victor', email: 'victor.peralta.gomez@gmail.com',
                         admin: true, password: '121212')
    @user = User.create(name: 'Victor', email: 'victorperaltagomez@gmail.com',
                        admin: false, password: '121212')
    @api = App.create(name: 'Front-End')
    Skill.create(name: 'Ruby')
    Skill.create(name: 'Rails')
    Skill.create(name: 'React')
  end

  after(:all) do
    @admin.destroy
    @user.destroy
    @api.destroy
    Skill.destroy_all
  end

  context 'Creating a provider' do
    it 'Create a provider with Admin Ok' do
      request.headers['Authorization'] = "Bearer #{@admin.token}"
      post :create, params: {
        name: 'Victor',
        bio: 'A programmer from Mexico',
        cost: 10,
        github_profile: 'https://github.com/VicPeralta',
        image: fixture_file_upload('victor.jpg', 'image/png'),
        skills: ['Ruby']
      }
      expect(response).to have_http_status(:ok)
      provider = Provider.order(:created_at).last
      assert provider.image.attached?
    end

    it 'Create a provider with User Unauthorized ' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      post :create, params: {
        name: 'Victor',
        bio: 'A programmer from Mexico',
        cost: 10,
        github_profile: 'https://github.com/VicPeralta',
        image: fixture_file_upload('victor.jpg', 'image/png'),
        skills: ['Ruby']
      }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'Validations creating a provider' do
    it 'Unprocessable due to missing cost' do
      request.headers['Authorization'] = "Bearer #{@admin.token}"
      post :create, params: {
        name: 'Victor', bio: 'A programmer from Mexico',
        github_profile: 'https://github.com/VicPeralta', image: fixture_file_upload('victor.jpg', 'image/png'),
        skills: ['Ruby']
      }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'Unprocessable due to missing name' do
      request.headers['Authorization'] = "Bearer #{@admin.token}"
      post :create, params: {
        name: '', bio: 'A programmer from Mexico',
        github_profile: 'https://github.com/VicPeralta', cost: 10,
        image: fixture_file_upload('victor.jpg', 'image/png'), skills: ['Ruby']
      }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'Unprocessable due to missing bio' do
      request.headers['Authorization'] = "Bearer #{@admin.token}"
      post :create, params: {
        name: '', github_profile: 'https://github.com/VicPeralta',
        cost: 10, image: fixture_file_upload('victor.jpg', 'image/png'), skills: ['Ruby']
      }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  context 'Missing image' do
    it 'Unprocessable due to missing image' do
      request.headers['Authorization'] = "Bearer #{@admin.token}"
      post :create, params: {
        name: '',
        bio: 'A programmer from Mexico',
        github_profile: 'https://github.com/VicPeralta',
        cost: 10,
        skills: ['Ruby']
      }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  context 'Getting list of providers' do
    it 'Ok get Providers' do
      request.headers['Authorization'] = "Bearer #{@api.token}"
      get :index
      expect(response).to have_http_status(:ok)
    end
    it 'Ok get list with 2 providers' do
      request.headers['Authorization'] = "Bearer #{@api.token}"
      Provider.create(name: 'Victor', bio: 'A programmer from Mexico',
                      cost: 10, image: fixture_file_upload('victor.jpg', 'image/png'))
      Provider.create(name: 'Victor', bio: 'A programmer from Mexico',
                      cost: 10, image: fixture_file_upload('victor.jpg', 'image/png'))
      get :index
      expect(response).to have_http_status(:ok)
      parse_body = JSON.parse(response.body)
      expect(parse_body.length).to be == 2
    end
  end

  context 'Get and Delete a provider ' do
    it 'Get a Provider Ok' do
      request.headers['Authorization'] = "Bearer #{@api.token}"
      provider = Provider.create(name: 'Victor', bio: 'A programmer from Mexico',
                                 cost: 10, image: fixture_file_upload('victor.jpg', 'image/png'))
      get :show, params: { id: provider.id }
      expect(response).to have_http_status(:ok)
      parse_body = JSON.parse(response.body)
      expect(parse_body['name']).to be == 'Victor'
    end
    it 'Destroy a provider with Admin Ok' do
      request.headers['Authorization'] = "Bearer #{@admin.token}"
      provider = Provider.create(name: 'Victor', bio: 'A programmer from Mexico',
                                 cost: 10, image: fixture_file_upload('victor.jpg', 'image/png'))
      get :destroy, params: { id: provider.id }
      expect(response).to have_http_status(:ok)
      expect(response.body).to be == '{"message":"Provider deleted"}'
    end
    it 'Destroy a provider with User Unauthorized' do
      request.headers['Authorization'] = "Bearer #{@user.token}"
      provider = Provider.create(name: 'Victor', bio: 'A programmer from Mexico',
                                 cost: 10, image: fixture_file_upload('victor.jpg', 'image/png'))
      get :destroy, params: { id: provider.id }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
