class CreateComponents < ActiveRecord::Migration
  def change
    create_table :components do |t|
    	
      t.integer :course_id

			t.string :name
			t.string :description

      t.timestamps
    end

    add_index :components, :name
    add_index :components, :course_id

  end
end
