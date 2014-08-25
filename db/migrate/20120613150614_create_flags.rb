class CreateFlags < ActiveRecord::Migration
  def change
    create_table :flags do |t|

      # A flag will only contain one of user_id, quiz_id, or video_id. Only one thing can be flagged per flag.

    	t.integer :user_id
    	t.integer :comment_id
    	t.integer :video_id
    	t.integer :quiz_id

    	t.string :cause

      t.timestamps
    end

    add_index :flags, :user_id
    add_index :flags, :comment_id
    add_index :flags, [:user_id, :comment_id]
    add_index :flags, :video_id
    add_index :flags, [:user_id, :video_id]
    add_index :flags, :quiz_id
    add_index :flags, [:user_id, :quiz_id]

  end
end