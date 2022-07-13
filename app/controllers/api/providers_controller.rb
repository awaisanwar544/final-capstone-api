class Api::ProvidersController < ApplicationController
  def admin_validation
    result = UsersHelper::Validator.valid_user_token?(request.headers['Authorization'])
    return false unless result[0]

    @user = result[0]
    @user.admin?
  end

  # GET /api/providers
  def index
    valid, error, status = UsersHelper::Validator.valid_app_token?(request.headers['Authorization'])
    unless valid
      # Invalid API token
      render json: { 'error:': error }, status: status
      return
    end
    render json: set_providers.to_json, status: :ok
  end

  # GET /api/providers/1
  def show
    valid, error, status = UsersHelper::Validator.valid_app_token?(request.headers['Authorization'])
    unless valid
      # Invalid API token
      render json: { 'error:': error }, status: status
      return
    end
    render json: set_provider.to_json, status: :ok
  end

  # POST /api/providers
  def create
    return render json: { 'error:': 'Admin access required' }, status: :unauthorized unless admin_validation

    @provider = Provider.new(provider_params)
    params[:skills].each do |skill|
      @provider.skills.push(Skill.find_by(name: skill))
    end
    if @provider.save
      render json: { message: 'Provider created' }, status: :created
    else
      render json: @provider.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/providers/1
  def destroy
    return render json: { 'error:': 'Admin access required' }, status: :unauthorized unless admin_validation

    @provider = Provider.find(params[:id])
    if @provider.destroy
      render json: { message: 'Provider deleted' }, status: :ok
    else
      render json: @provider.errors, status: :unprocessable_entity
    end
  end

  private

  def set_providers
    @providers = []
    Provider.all.each do |provider|
      skills = []
      provider.skills.each do |skill|
        skills.push({
                      id: skill.id,
                      name: skill.name
                    })
      end
      @providers.push({
                        id: provider.id,
                        name: provider.name,
                        bio: provider.bio,
                        cost: provider.cost,
                        image: url_for(provider.image),
                        github_profile: provider.github_profile,
                        linkedin_profile: provider.linkedin_profile,
                        twitter_profile: provider.twitter_profile,
                        skills:
                      })
    end
    @providers
  end

  def set_provider
    provider = Provider.find(params[:id])
    skills = []
    provider.skills.each do |skill|
      skills.push({
                    id: skill.id,
                    name: skill.name
                  })
    end
    {
      id: provider.id,
      name: provider.name,
      bio: provider.bio,
      cost: provider.cost,
      image: url_for(provider.image),
      github_profile: provider.github_profile,
      linkedin_profile: provider.linkedin_profile,
      twitter_profile: provider.twitter_profile,
      skills:
    }
  end

  # Only allow a trusted parameter "white list" through.
  def provider_params
    params.permit(:name, :bio, :cost, :image, :github_profile, :linkedin_profile, :twitter_profile)
  end
end
