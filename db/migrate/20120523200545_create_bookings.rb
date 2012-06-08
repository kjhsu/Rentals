class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.integer :user_id
      t.integer :listing_id
      t.date :checkin
      t.date :checkout
      t.integer :num_guests

      t.timestamps
    end
  end
end
