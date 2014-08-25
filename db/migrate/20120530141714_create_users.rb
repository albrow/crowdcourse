class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
    	
      t.string :full_name
      t.integer :points, :default => 0
      t.integer :avg_quiz_score

      t.timestamps
    end

  end
end
