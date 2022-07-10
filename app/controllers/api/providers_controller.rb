class Api::ProvidersController < ApplicationController
  # GET /api/providers
  def index
    @providers = Provider.all
    render json: @providers
  end

  # GET /api/providers/1
  def show
    @provider = Provider.find(params[:id])
    render json: @provider
  end

  # POST /api/providers
  def create
    @provider = Provider.new(provider_params)
    if @provider.save
      render json: { message: 'Provider created' }
    else
      render json: @provider.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/providers/1
  def destroy
    @provider = Provider.find(params[:id])
    if @provider.destroy
      render json: { message: 'Provider deleted' }
    else
      render json: @provider.errors, status: :unprocessable_entity
    end
  end

  private

  def set_providers
    @providers = []
    Provider.all.each do |provider|
      @providers.push({
                        id: provider.id,
                        name: provider.name,
                        bio: provider.bio,
                        cost: provider.cost,
                        image: url_for(provider.image),
                        github_profile: provider.github_profile,
                        linkedin_profile: provider.linkedin_profile,
                        twitter_profile: provider.twitter_profile
                      })
    end
    @providers
  end

  def set_provider
    provider = Provider.find(params[:id])
    {
      id: provider.id,
      name: provider.name,
      bio: provider.bio,
      cost: provider.cost,
      image: url_for(provider.image),
      github_profile: provider.github_profile,
      linkedin_profile: provider.linkedin_profile,
      twitter_profile: provider.twitter_profile
    }
  end

  # Only allow a trusted parameter "white list" through.
  def provider_params
    params.permit(:name, :bio, :cost, :image, :github_profile, :linkedin_profile, :twitter_profile)
  end
end
