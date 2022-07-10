require 'rails_helper'

RSpec.describe Api::ProvidersController, type: :controller do
  context 'Creating a provider' do
    it 'Ok Provider created' do
      post :create, params: {
        name: 'Victor',
        bio: 'A programmer from Mexico',
        cost: 10,
        github_profile: 'https://github.com/VicPeralta',
        image: fixture_file_upload('victor.jpg', 'image/png')
      }
      expect(response).to have_http_status(:ok)
      provider = Provider.order(:created_at).last
      assert provider.image.attached?
    end
  end
  context 'Validations creating a provider' do
    it 'Unprocessable due to missing cost' do
      post :create, params: {
        name: 'Victor',
        bio: 'A programmer from Mexico',
        github_profile: 'https://github.com/VicPeralta',
        image: fixture_file_upload('victor.jpg', 'image/png')
      }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'Unprocessable due to missing name' do
      post :create, params: {
        name: '',
        bio: 'A programmer from Mexico',
        github_profile: 'https://github.com/VicPeralta',
        cost: 10,
        image: fixture_file_upload('victor.jpg', 'image/png')
      }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'Unprocessable due to missing bio' do
      post :create, params: {
        name: '',
        github_profile: 'https://github.com/VicPeralta',
        cost: 10,
        image: fixture_file_upload('victor.jpg', 'image/png')
      }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
  context 'Missing image' do
    it 'Unprocessable due to missing image' do
      post :create, params: {
        name: '',
        bio: 'A programmer from Mexico',
        github_profile: 'https://github.com/VicPeralta',
        cost: 10
      }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  context 'Getting list of providers' do
    it 'Ok get Providers' do
      get :index
      expect(response).to have_http_status(:ok)
    end
    it 'Ok get list with 2 providers' do
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
    it 'Ok get Provider' do
      provider = Provider.create(name: 'Victor', bio: 'A programmer from Mexico',
                                 cost: 10, image: fixture_file_upload('victor.jpg', 'image/png'))
      get :show, params: { id: provider.id }
      expect(response).to have_http_status(:ok)
      parse_body = JSON.parse(response.body)
      expect(parse_body['name']).to be == 'Victor'
    end
    it 'Ok destroy a Provider' do
      provider = Provider.create(name: 'Victor', bio: 'A programmer from Mexico',
                                 cost: 10, image: fixture_file_upload('victor.jpg', 'image/png'))
      get :destroy, params: { id: provider.id }
      expect(response).to have_http_status(:ok)
      expect(response.body).to be == '{"message":"Provider deleted"}'
    end
  end
end
