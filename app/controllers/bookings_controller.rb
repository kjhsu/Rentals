class BookingsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @bookings = current_user.bookings.all

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


  def create
    @booking = current_user.bookings.new params[:booking]

    # Temporarily leave schedule in here
    if @booking.checkin and @booking.checkout and @booking.listing
      timeblock = @booking.listing.time_blocks.in_range(@booking.checkin.to_s, @booking.checkout.to_s).first
      timeblock.schedule(@booking.checkin.to_s, @booking.checkout.to_s)
    end

    respond_to do |format|
      if @booking.save
        format.html { redirect_to @booking, notice: 'Booking created successfully.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @booking = Booking.find params[:id]

    respond_to do |format|
      if @booking.update_attributes params[:booking]
        format.html { redirect_to @booking, notice: 'Booking updated successfully.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @booking = Booking.find params[:id]
    @booking.destory

    respond_to do |format|
      format.html { redirect_to 'hosts'}
    end
  end
end
