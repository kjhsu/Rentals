class CreateAmenitiesListings < ActiveRecord::Migration
  def change
    create_table :amenities_listings, :id => false do |t|
      t.integer :amenity_id
      t.integer :listing_id
    end

    add_index :amenities_listings, [:amenity_id, :listing_id]
  end
end
