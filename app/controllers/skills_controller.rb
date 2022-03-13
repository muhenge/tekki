class SkillsController < ApplicationController
  before_action :set_skill, only: %i[show edit update destroy]
  before_action :authenticate_user!, only: %i[create edit]
  #before_action :current_user, only: %i[create edit]
  # GET /skills or /skills.json
  def index
    @skills = Skill.all
  end

  # GET /skills/1 or /skills/1.json
  def show
  end

  # GET /skills/new
  def new
    @skill = current_user.skills.build(skill_params)
  end

  # GET /skills/1/edit
  def edit
  end

  # POST /skills or /skills.json
  def create
    @skill = current_user.skills.build(skill_params)
    
      if @skill.save
        redirect_to edit_user_registration_path, notice:"Skill added successfully"
      else
       redirect_to edit_user_registration_path, alert:"Failed, check if skill level is provided"
      end
  end

  # PATCH/PUT /skills/1 or /skills/1.json
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
      params.permit(:name, :level, :user_id, :user_slug)
    end
end
