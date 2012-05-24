class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.integer :user_id
      t.integer :neighborhood_id
      t.string :title
      t.integer :property_type
      t.integer :max_guests
      t.integer :rooms
      t.boolean :certified
      t.integer :extra_cost
      t.integer :daily_price
      t.integer :weekly_price
      t.integer :monthly_price
      t.integer :size
      t.integer :cancellation_policy_id
      t.integer :checkin
      t.integer :checkout
      t.integer :deposit

      t.timestamps
    end
  end
end
