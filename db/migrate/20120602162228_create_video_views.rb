class CreateVideoViews < ActiveRecord::Migration
  def change
    create_table :video_views do |t|
			
			t.integer :viewer_id
			t.integer :video_id
			t.boolean :finished

      t.timestamps
    end

    add_index :video_views, :video_id
    add_index :video_views, :viewer_id
    add_index :video_views, [:video_id, :viewer_id]
    
  end
end
