class Listing < ActiveRecord::Base
  belongs_to :user
  belongs_to :neighborhood
  belongs_to :cancellation_policy
  has_many :time_blocks
  has_and_belongs_to_many :amenities

  scope :in_city, lambda { |city|
    joins('JOIN neighborhoods n on listings.neighborhood_id = n.id JOIN cities c on n.city_id = c.id').where(['c.name = ?', city])
  }

  scope :in_neighborhood, lambda { |n| joins('JOIN neighborhoods').where(['neighborhoods.name = ?', n])}
  scope :accomodates, lambda { |num| where(['max_guests >= ?', num]) }

  scope :sort_by_price, lambda { order('daily_price ASC') }
  scope :sort_by_newest, lambda { order('created_at DESC') }
  scope :sort_by_id, lambda { order('id ASC') }

  after_create :init_timeblock

  def type
    case self.property_type
    when 1 then
      :"room"
    when 2 then
      :"apartment"
    when 3 then
      :"house"
    end
  end

  def booked_dates(year, month)
    begin_date = Date.new year, month, 1
    end_date = begin_date + 1.month
    booked_dates = []
    booked_blocks = time_blocks.where(is_free: false).where(["begin_date <= ? and end_date >= ?", end_date, begin_date]).order('begin_date ASC')
    booked_blocks.each do |booked_block|
      d1 = booked_block.begin_date < begin_date ? begin_date : booked_block.begin_date
      d2 = booked_block.end_date > end_date ? end_date - 1 : booked_block.end_date - 1
      (d1..d2).each do |date|
        booked_dates << date
      end
    end
    return booked_dates
  end

  private
  def init_timeblock
    self.time_blocks.create
  end
end
