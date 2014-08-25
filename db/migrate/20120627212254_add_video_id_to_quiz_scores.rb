class AddVideoIdToQuizScores < ActiveRecord::Migration
  def up
		change_table :quiz_scores do |t|
			t.integer :video_id
		end

		add_index :quiz_scores, :video_id
  end

  def down
		remove_index :quiz_scores, :video_id
		remove_column :quiz_scores, :video_id
  end

end
