class TimeBlock < ActiveRecord::Base
  belongs_to :listing

  validates_presence_of :listing_id

  scope :in_range, lambda { |begin_date, end_date|
    begin
      where(['begin_date <= ? and end_date >= ?', Date.parse(begin_date), Date.parse(end_date)])
    rescue
      limit(0)
    end
  }

  def include?(begin_date, end_date)
    begin_date, end_date = valid_range(begin_date, end_date)
    if begin_date.nil? or end_date.nil?
      false
    else
      self.begin_date <= begin_date and self.end_date >= end_date
    end
  end

  def schedule(begin_date, end_date)
    begin_date, end_date = valid_range(begin_date, end_date)
    if !free? or begin_date.nil? or end_date.nil? or self.begin_date > begin_date or self.end_date < end_date
      return false
    end

    if self.begin_date < begin_date
      TimeBlock.create begin_date: self.begin_date, end_date: begin_date, listing_id: self.listing_id
    end

    if self.end_date > end_date
      TimeBlock.create begin_date: end_date, end_date: self.end_date, listing_id: self.listing_id
    end

    self.update_attributes begin_date: begin_date, end_date: end_date, is_free: false
  end

  def unschedule
    begin_date = self.begin_date
    end_date = self.end_date

    if (previous_free = TimeBlock.where(end_date: begin_date, listing_id: self.listing_id, is_free: true).first)
      begin_date = previous_free.begin_date
      previous_free.destroy
    end

    if (next_free = TimeBlock.where(begin_date: end_date, listing_id: self.listing_id, is_free: true).first)
      end_date = next_free.end_date
      next_free.destroy
    end

    self.update_attributes begin_date: begin_date, end_date: end_date, is_free: true
  end

  def free?
    is_free
  end

  private
  def valid_range begin_date, end_date
    begin
      begin_date = Date.parse begin_date
      end_date = Date.parse end_date
    rescue
      return []
    end

    if begin_date < end_date
      [begin_date, end_date]
    else
      []
    end
  end
end
