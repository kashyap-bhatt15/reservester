class UsersController < ApplicationController
  before_filter :authenticate_user!, :is_owner?
   
  def dashboard
    @user = current_user
    @restaurants = current_user.restaurants
    # @restaurants = Restaurant.where("owner_id = ?", current_user.id)
  end

  private
  def is_owner?
  	if current_user.is_owner?
  	else
  		redirect_to root_path, alert: "Unauthorized access / URL Inaccessible"
  	end
  end
end