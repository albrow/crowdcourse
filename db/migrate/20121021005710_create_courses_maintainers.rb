class CreateCoursesMaintainers < ActiveRecord::Migration
  def change
 		create_table :courses_maintainers do |t|
     	t.integer :course_id
     	t.integer :maintainer_id
    end

		add_index :courses_maintainers, :course_id
		add_index :courses_maintainers, :maintainer_id
		add_index :courses_maintainers, [:course_id, :maintainer_id]
  end
end
