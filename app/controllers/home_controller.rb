class HomeController < ApplicationController
  def index
  end

  def search
    query = Listing.in_city(params[:city])

    begin
      begin_date = Date.parse params[:start]
      end_date = Date.parse params[:end]
      query = query.joins(:time_blocks).where(time_blocks: { is_free: true })
      query = query.where(['time_blocks.begin_date <= ? and time_blocks.end_date >= ?', begin_date, end_date])
    rescue
    end

    if (num_guests = params[:num_guests].to_i) > 0
      query = query.accomodates num_guests
    end


    case params[:sort_by]
    when '1' then
      query = query.sort_by_price
    when '2' then
      query = query.sort_by_newest
    else
      query = query.sort_by_id
    end

    page = params[:page].to_i
    page = page > 0 ? page : 1
    @listings = query.paginate(:page => page, :per_page => 20)
  end
end
