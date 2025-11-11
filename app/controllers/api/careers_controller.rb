class Api::CareersController < ApplicationController
  def index
    careers = Career.all
    render json: {
      careers:careers
    }
  end
  
  def create
    career = Career.new(career_params)
    if career.save
      render json: career
    else
      render json: { errors: career.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def show
    career = Career.find(params[:id])
    render json: career
  end
  
  def update
    career = Career.find(params[:id])
    if career.update(career_params)
      render json: career
    else
      render json: { errors: career.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def career_params
    params.require(:career).permit(:field)
  end
end
