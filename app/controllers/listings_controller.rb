class ListingsController < ApplicationController
  def show
    @listing = Listing.find params[:id]

    respond_to do |format|
      format.html
    end
  end
end
