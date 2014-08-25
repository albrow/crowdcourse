class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|

			t.integer :component_id
			t.integer :creator_id #(user)

      # makes sorting by number of flags easier
      t.integer :flags_count

    	t.string :type
    	t.string :url
    	t.integer :duration #in seconds
    	t.integer :avg_rating, :default => 3
    	t.integer :avg_quiz_score
			

      t.timestamps
    end

    add_index :videos, :component_id
    add_index :videos, :creator_id
    add_index :videos, :url # may be accessed during embedding
    
  end
end
