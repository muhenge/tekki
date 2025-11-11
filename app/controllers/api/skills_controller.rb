class Api::SkillsController < ApplicationController
  before_action :authenticate_user!, only: %i[create update destroy]
  before_action :set_skill, only: %i[update destroy]

  # POST /api/skills
  def create
    skills = params.require(:skills).map do |skill_params|
      skill_params = skill_params.permit(:name)

      # Find or create skill
      current_user.skills.find_or_initialize_by(name: skill_params[:name])
    end

    if skills.all?(&:valid?)
      skills.each(&:save)
      render json: { skills: skills, message: 'Skills processed successfully' }, status: :ok
    else
      render json: { errors: skills.map { |s| s.errors.full_messages } }, status: :unprocessable_entity
    end
  end
  # PATCH/PUT /api/skills/:id
  def update
    if @skill.update(skill_params)
      render json: { skill: @skill, message: 'Skill updated successfully' }, status: :ok
    else
      render json: { errors: @skill.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/skills/:id
  def destroy
    if @skill.destroy
      render json: { message: 'Skill deleted successfully' }, status: :ok
    else
      render json: { message: 'Failed to delete skill' }, status: :unprocessable_entity
    end
  end

  private

  def set_skill
    @skill = current_user.skills.find_by(id: params[:id])
    render json: { message: 'Skill not found' }, status: :not_found unless @skill
  end

  def skill_params
    params.require(:skill).permit(:name)
  end
end
