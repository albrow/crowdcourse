class CreateChoiceQuestions < ActiveRecord::Migration
  def change
    create_table :choice_questions do |t|
			
			t.integer :quiz_id

			t.text :description

      t.timestamps
    end

    add_index :choice_questions, :quiz_id
    
  end
end
