class Api::CareersController < ApplicationController
  def index
    careers = Career.all
    render json: {
      careers:careers
    }
  end
end
