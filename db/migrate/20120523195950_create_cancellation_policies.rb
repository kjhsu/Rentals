class CreateCancellationPolicies < ActiveRecord::Migration
  def change
    create_table :cancellation_policies do |t|
      t.string :name

      t.timestamps
    end
  end
end
