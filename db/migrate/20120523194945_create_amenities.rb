class CreateAmenities < ActiveRecord::Migration
  def change
    create_table :amenities do |t|
      t.string :name
      t.integer :priority

      t.timestamps
    end
  end
end
