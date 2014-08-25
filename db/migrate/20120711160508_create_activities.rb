class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
			
			t.integer :user_id
			t.string :kind # tried to use type, but it's reserved
			t.text :data

      t.timestamps
    end

    add_index :activities, :user_id
  end
end
