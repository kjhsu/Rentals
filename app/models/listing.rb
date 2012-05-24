class Listing < ActiveRecord::Base
  belongs_to :user
  belongs_to :neighborhood
  belongs_to :cancellation_policy
  has_and_belongs_to_many :amenities

  scope :in_city, lambda { |city|
    joins('JOIN neighborhoods n on listings.neighborhood_id = n.id JOIN cities c on n.city_id = c.id').where(['c.name = ?', city])
  }

  scope :in_neighborhood, lambda { |n| joins('JOIN neighborhoods').where(['neighborhoods.name = ?', n])}
  scope :accomodates, lambda { |num| where(['max_guests >= ?', num]) }

  scope :sort_by_price, lambda { order('daily_price ASC') }
  scope :sort_by_newest, lambda { order('created_at DESC') }

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
end
