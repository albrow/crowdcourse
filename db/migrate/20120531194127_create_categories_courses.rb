class CreateCategoriesCourses < ActiveRecord::Migration
  def change
 		create_table :categories_courses do |t|
     	t.integer :category_id
     	t.integer :course_id
    end

		add_index :categories_courses, :category_id
		add_index :categories_courses, :course_id
		add_index :categories_courses, [:category_id, :course_id]
  end
end
