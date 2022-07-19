require 'swagger_helper'

RSpec.describe 'Providers API', type: :request do
  before(:all) do
    @admin = User.create(name: 'Victor', email: 'victor.peralta.gomez@gmail.com',
                         admin: true, password: '121212')
    @user = User.create(name: 'Victor', email: 'victorperaltagomez@gmail.com',
                        admin: false, password: '121212')
    @api = App.create(name: 'Front-End')
    Skill.create(name: 'Ruby')
    Skill.create(name: 'Rails')
    Skill.create(name: 'React')
    Provider.create(name: 'Victor', bio: 'A programmer from Mexico',
                    image: fixture_file_upload('victor.jpg', 'image/png'),
                    cost: 10, github_profile: 'https://github.com/VicPeralta',
                    linkedin_profile: 'https://www.linkedin.com/in/vicperalta/',
                    twitter_profile: 'https://twitter.com/VicPeralta')
    Provider.create(name: 'Victor', bio: 'A programmer from Mexico',
                    image: fixture_file_upload('victor.jpg', 'image/png'),
                    cost: 10, github_profile: 'https://github.com/VicPeralta',
                    linkedin_profile: 'https://www.linkedin.com/in/vicperalta/',
                    twitter_profile: 'https://twitter.com/VicPeralta')
    Provider.create(name: 'Victor', bio: 'A programmer from Mexico',
                    image: fixture_file_upload('victor.jpg', 'image/png'),
                    cost: 10, github_profile: 'https://github.com/VicPeralta',
                    linkedin_profile: 'https://www.linkedin.com/in/vicperalta/',
                    twitter_profile: 'https://twitter.com/VicPeralta')
  end

  after(:all) do
    @admin.destroy
    @user.destroy
    @api.destroy
    Skill.destroy_all
    Provider.destroy_all
  end

  path '/api/providers' do
    get 'Get providers list with API token' do
      security [BearerAuth: []]
      response '200', 'Get Providers list successfully' do
        let(:Authorization) { "Bearer #{@api.token}" }
        produces 'application/json'
        schema type: :array,
               properties: {
                 id: { type: :integer }, name: { type: :string },
                 image: { type: :string }, bio: { type: :string },
                 cost: { type: :decimal }, github_profile: { type: :string },
                 linkedin_profile: { type: :string },
                 twitter_profile: { type: :string },
                 skills: { type: :array,
                           items: {
                             properties: {
                               id: { type: :integer },
                               name: { type: :string }
                             }
                           } }
               },
               required: %w[id name bio]
        run_test!
      end
      response '403', 'Unauthorized App' do
        let(:Authorization) { 'Bearer ' }
        run_test!
      end
    end
  end

  path '/api/providers/{id}' do
    delete 'Delete a provider with User token' do
      security [BearerAuth: []]
      parameter name: :id, in: :path, type: :integer, required: true,
                example: 1, description: 'The provider\'s ID'
      response '200', 'Delete a provider with an Admin' do
        produces 'application/json'
        let(:Authorization) { "Bearer #{@admin.token}" }
        let(:id) { Provider.first.id }
        run_test!
      end
      response '401', 'Delete a provider with a User' do
        produces 'application/json'
        let(:Authorization) { "Bearer #{@user.token}" }
        let(:id) { Provider.first.id }
        run_test!
      end
      # response '404', 'Delete a non existance provider' do
      #   produces 'application/json'
      #   let(:Authorization) { "Bearer #{@admin.token}" }
      #   let(:id) { 1024 }
      #   run_test!
      # end
    end
  end

  path '/api/providers/{id}' do
    get 'Get a provider\'s info with API token' do
      security [BearerAuth: []]
      parameter name: :id, in: :path, type: :integer, required: true,
                example: 1, description: 'The provider\'s ID'
      response '200', 'Get provider\'s info' do
        produces 'application/json'
        let(:Authorization) { "Bearer #{@api.token}" }
        let(:id) { Provider.first.id }
        run_test!
      end
      # response '404', 'Get non existance provider' do
      #   produces 'application/json'
      #   let(:Authorization) { "Bearer #{@api.token}" }
      #   let(:id) { 1024 }
      #   run_test!
      # end
    end
  end
  # rubocop:disable Metrics
  path '/api/providers' do
    post 'Create a provider with User token' do
      consumes 'multipart/form-data'
      produces 'application/json'
      security [BearerAuth: []]
      parameter name: :provider, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: 'Victor Peralta' },
          bio: { type: :string, example: 'A programmer from Mexico' },
          cost: { type: :integer, example: 10 },
          skills: { type: :array, example: ['Ruby'] },
          image: { type: :file }
        },
        required: %w[name bio cost skills image]
      }
      parameter name: :name, in: :formData, type: :string, required: true, example: 'Victor Peralta',
                description: 'The provider\'s name'
      parameter name: :bio, in: :formData, type: :string, required: true
      parameter name: :cost, in: :formData, type: :integer, required: true
      parameter name: :skills, in: :formData, type: :array, required: true
      parameter name: :image, in: :formData, type: :file, required: true
      response '201', 'Create a provider with an admin' do
        let(:Authorization) { "Bearer #{@admin.token}" }
        let(:name) { 'Victor' }
        let(:bio) { 'A programmer from Mexico' }
        let(:cost) { 10 }
        let(:skills) { ['Ruby'] }
        let(:image) { fixture_file_upload('victor.jpg', 'image/png') }
        run_test!
      end
      response '401', 'Create a provider with a user' do
        let(:Authorization) { "Bearer #{@user.token}" }
        let(:name) { 'Victor' }
        let(:bio) { 'A programmer from Mexico' }
        let(:cost) { 10 }
        let(:skills) { ['Ruby'] }
        let(:image) { fixture_file_upload('victor.jpg', 'image/png') }
        run_test!
      end
      response '422', 'Create a provider with incorrect data' do
        let(:Authorization) { "Bearer #{@admin.token}" }
        let(:name) { '' }
        let(:bio) { 'A programmer from Mexico' }
        let(:cost) { 10 }
        let(:skills) { ['Ruby'] }
        let(:image) { fixture_file_upload('victor.jpg', 'image/png') }
        run_test!
      end
    end
  end
  # rubocop:enable Metrics
end
