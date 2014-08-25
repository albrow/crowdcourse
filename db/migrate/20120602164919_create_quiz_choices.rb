class CreateQuizChoices < ActiveRecord::Migration
  def change
    create_table :quiz_choices do |t|
			
			t.integer :question_id

			t.text :content

      t.timestamps
    end

    add_index :quiz_choices, :question_id
    
  end
end
