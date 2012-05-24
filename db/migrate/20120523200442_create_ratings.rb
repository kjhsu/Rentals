class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :overall
      t.integer :accuracy
      t.integer :cleanliness
      t.integer :checkin
      t.integer :communication
      t.integer :location
      t.integer :value

      t.timestamps
    end
  end
end
