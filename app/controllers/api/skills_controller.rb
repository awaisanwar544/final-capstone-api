class Api::SkillsController < ApplicationController
  def admin_validation
    result = UsersHelper::Validator.valid_user_token?(request.headers['Authorization'])
    return false unless result[0]

    @user = result[0]
    @user.admin?
  end

  # GET /api/skills
  def index
    render json: set_skills.to_json
  end

  # POST /api/skills
  def create
    return render json: { 'error:': 'Admin access required' }, status: :unauthorized unless admin_validation

    skill = Skill.new(skill_params)
    if skill.save
      render json: { message: 'Skill created!' }
    else
      render json: skill.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/skills/1
  def destroy
    return render json: { 'error:': 'Admin access required' }, status: :unauthorized unless admin_validation

    skill = Skill.find(params[:id])
    if skill.destroy
      render json: { message: 'Skill deleted!' }
    else
      render json: skill.errors, status: :unprocessable_entity
    end
  end

  private

  def set_skills
    skills = []
    Skill.all.each do |skill|
      skills.push({
                    id: skill.id,
                    name: skill.name
                  })
    end
    skills
  end

  def skill_params
    params.permit(:name)
  end
end
