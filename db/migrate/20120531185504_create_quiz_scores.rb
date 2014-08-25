class CreateQuizScores < ActiveRecord::Migration
  def change
    create_table :quiz_scores do |t|
      
			t.integer :user_id
			t.integer :quiz_id

			t.integer :score

      t.timestamps
    end

    add_index :quiz_scores, :user_id
    add_index :quiz_scores, :quiz_id
    add_index :quiz_scores, [:user_id, :quiz_id]
    
  end
end
