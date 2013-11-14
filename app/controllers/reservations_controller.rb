class ReservationsController < ApplicationController
	before_filter :authenticate_user!

  before_filter :is_restaurant_owner? , only: [:new]

  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    # New Reservation form on the show page only
    @reservation = Reservation.new
  end

  def create
    @restaurant = Restaurant.find params[:restaurant_id]
    @reservation = @restaurant.reservations.build params[:reservation]

    if @reservation.save
      ReservationMailer.reservation_notification_user_email(@reservation).deliver
      ReservationMailer.reservation_notification_owner_email(@reservation).deliver
     
      redirect_to @restaurant, :notice => 'Your reservation has been created'
    else
      render 'restaurants/show', :error => 'For some unknown reasons your reservation was not sent to restaurant'
      #redirect_to root_path
    end
  end

  def destroy
    @reservation = Reservation.find params[:id]
    @reservation.destroy

    redirect_to @reservation.restaurant
  end

  def is_restaurant_owner?
    restaurant = Restaurant.find(params[:restaurant_id])
    unless restaurant.belong_to?(current_user)
      return
    else
      flash[:info] = "You are making reservation for your own restaurant."
      return
    end
  end
end
