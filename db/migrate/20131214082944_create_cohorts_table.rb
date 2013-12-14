class CreateCohortsTable < ActiveRecord::Migration
  def up
    create_table :cohorts, {:id => false} do |t|
      t.integer :c_id
      t.string :cohort_name
      t.string :location

      t.timestamps
    end
  end

  def down
    drop_table :cohorts
  end
end
