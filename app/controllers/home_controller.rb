class HomeController < ApplicationController
  def index
  end

  def search
    query = Listing.in_city(params[:city])

    if (num_guests = params[:num_guests].to_i) > 0
      query = query.accomodates num_guests
    end

    case params[:sort_by]
    when '1' then
      query = query.sort_by_price
    when '2' then 
      query = query.sort_by_newest
    end

    page = params[:page].to_i
    page = page > 0 ? page : 1
    @listings = query.paginate(:page => page, :per_page => 20)
  end
end
