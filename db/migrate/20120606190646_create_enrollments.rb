class CreateEnrollments < ActiveRecord::Migration
  def change
    create_table :enrollments do |t|

			t.integer :course_id
			t.integer :user_id

    	t.integer :progress_as_percent, :default => 0
    	t.integer :num_videos_watched, :default => 0
    	t.integer :num_quizzes_passed, :default => 0

      t.timestamps
    end

    add_index :enrollments, :course_id
    add_index :enrollments, :user_id
    add_index :enrollments, [:user_id, :course_id]
    
  end
end
