class CreateComponentsCourses < ActiveRecord::Migration
  def change
		create_table :components_courses do |t|
     	t.integer :component_id
     	t.integer :course_id
    end

		add_index :components_courses, :component_id
		add_index :components_courses, :course_id
		add_index :components_courses, [:component_id, :course_id]

  end
end
