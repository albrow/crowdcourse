class AddAnswerToQuizChoices < ActiveRecord::Migration
   def up
    change_table :quiz_choices do |t|
      t.boolean :is_answer, :default => false
    end
  end
 
  def down
    remove_column :quiz_choices, :is_answer
  end

end
