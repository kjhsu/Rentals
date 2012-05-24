class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.integer :user_id
      t.integer :listing_id
      t.date :begin_date
      t.date :end_date

      t.timestamps
    end
  end
end
