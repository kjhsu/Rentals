class CreateTimeBlocks < ActiveRecord::Migration
  def change
    create_table :time_blocks do |t|
      t.date :begin_date, :default => Date.new(2012,1,1)
      t.date :end_date, :default => Date.new(2030,1,1)
      t.boolean :is_free, :default => true
      t.integer :listing_id

      t.timestamps
    end
  end
end
