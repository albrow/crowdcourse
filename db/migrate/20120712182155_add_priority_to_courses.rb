class AddPriorityToCourses < ActiveRecord::Migration
  def up
  	change_table :courses do |t|
			t.integer :priority
  	end

  	add_index :courses, :priority
  end

  def down
  	remove_index :courses, :priority
  	remove_column :courses, :priority
  end
end
