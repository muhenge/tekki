class Api::SkillsController < ApplicationController
  before_action :set_skill, only: %i[show edit update destroy]
  before_action :authenticate_user!, only: %i[create edit]


  def new
    @skill = current_user.skills.build(skill_params)
  end

  # GET /skills/1/edit
  def edit
  end

  # POST /skills or /skills.json
  def create
    skill = current_user.skills.build(skill_params)
    all_skills = []
      if skill.save
        all_skills.push(skill)
        render json: {
          skills: all_skills,
          message:"Skills saved"
        }, status: :ok
      else
        render json: {
          message:"An error occurs, skills not saved"
        }
      end
  end


  def update
      if @skill.update(skill_params)
        redirect_to user_path(current_user), notice:"Skill updated"
      else
        redirect_to user_path(current_user), alert:"Failed"
      end
  end

  # DELETE /skills/1 or /skills/1.json
  def destroy
    @skill.destroy
    redirect_to user_path(current_user), notice:"#{current_user.skills.name} deleted"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_skill
      @skill = Skill.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def skill_params
      params.permit(:name, :level)
    end
end
