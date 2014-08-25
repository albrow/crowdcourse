class CreateVideoRatings < ActiveRecord::Migration
  def change
    create_table :video_ratings do |t|
			
			t.integer :video_id
			t.integer :rater_id

			t.integer :value

      t.timestamps
    end

    add_index :video_ratings, :video_id
    add_index :video_ratings, :rater_id
    add_index :video_ratings, [:video_id, :rater_id]
    
  end
end
