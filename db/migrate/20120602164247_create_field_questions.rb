class CreateFieldQuestions < ActiveRecord::Migration
  def change
    create_table :field_questions do |t|

			t.integer :quiz_id

			t.text :description
			t.text :answer
			t.string :field_type

      t.timestamps
    end

    add_index :field_questions, :quiz_id
    
  end
end
