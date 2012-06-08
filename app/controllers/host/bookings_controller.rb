class Host::BookingsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @bookings = Booking.all

    respond_to do |format|
      format.html
    end
  end

  def show
    @booking = Booking.find params[:id]

    respond_to do |format|
      format.html
    end
  end

  def confirm
  end
end
