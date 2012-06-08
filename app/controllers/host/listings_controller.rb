class Host::ListingsController < ApplicationController
  before_filter :authenticate_user!

  def new
    @listing = Listing.new

    respond_to do |format|
      format.html
    end
  end

  def create
    @listing = Listing.new params[:listing]

    respond_to do |format|
      if @listing.save
        format.html { redirect_to @listing, notice: 'Listing created successfully.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @listing = Listing.find params[:id]

    respond_to do |format|
      if @listing.update_attributes params[:listing]
        format.html { redirect_to @listing, notice: 'Listing updated successfully.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @listing = Listing.find params[:id]
    @listing.destory

    respond_to do |format|
      format.html { redirect_to 'hosts'}
    end
  end
end
