class AddPriorityAndAliasToComponents < ActiveRecord::Migration
  def up
  	change_table :components do |t|
			t.integer :priority # used for sorting
			t.string :alias
  	end
  end

  def down
		remove_column :components, :alias
		remove_column :components, :priority
  end
end
