class CreateQuizzes < ActiveRecord::Migration
  def change
    create_table :quizzes do |t|
			
			t.integer :component_id
      
      # makes sorting by number of flags easier
      t.integer :flags_count, :default => 0

			t.integer :avg_score
			t.integer :num_questions, :default => 0

      t.timestamps
    end

    add_index :quizzes, :component_id
    
  end
end
