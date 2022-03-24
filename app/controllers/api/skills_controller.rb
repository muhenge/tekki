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
      if skill.save
        render json: {
          skill: skill,
          message:"Skills saved"
        }, status: :ok
      else
        render json: {
          message:"An error occurs, skills not saved"
        }
      end
  end

  def update
      if current_user.skills.update(skill_params)
        render json: {
          skill: @skill,
        }, status: :ok
      else
        render json: {
          message:"An error occurs, skills not saved"
        }
      end
  end

  def destroy
    @skill.destroy
    render json: {
      message:"Skill deleted"
    }, status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_skill
      @skill = Skill.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def skill_params
      params.require(:skill).permit(:name, :level)
    end
end
