class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.integer :listing_id
      t.string :language
      t.string :description

      t.timestamps
    end
  end
end
