class AddFieldsToCourses < ActiveRecord::Migration
  def change
  	add_column :courses, :others_can_add_videos, :boolean, :default => true
  	add_column :courses, :others_can_add_quizzes, :boolean, :default => true
  	add_column :courses, :others_can_add_lessons, :boolean, :default => true
  	add_column :courses, :others_can_edit_quizzes, :boolean, :default => false
  	add_column :courses, :others_can_edit_lessons, :boolean, :default => false
  	add_column :courses, :others_can_request_to_be_maintainers, :boolean, :default => true
  end
end
