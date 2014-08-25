class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      
      t.integer :user_id
      t.integer :video_id
      t.integer :quiz_id

      # makes sorting by number of flags easier
      t.integer :flags_count, :default => 0

      t.text :content

      t.timestamps
    end

    add_index :comments, :user_id
    add_index :comments, :quiz_id
    add_index :comments, [:user_id, :quiz_id]
    add_index :comments, :video_id
    add_index :comments, [:user_id, :video_id]
    
  end
end
