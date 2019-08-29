class Api::V0::UsersController < ApplicationController
  before_action :authenticate_user!  
  
  def show
    render json: current_user.registration_keys.pluck(:combination)
  end
end
