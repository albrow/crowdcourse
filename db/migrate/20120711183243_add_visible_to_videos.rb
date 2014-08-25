class AddVisibleToVideos < ActiveRecord::Migration
  
  def up 
  	change_table :videos do |t|
  		t.boolean :visible, :default => true
  	end
  end

  def down
		remove_column :videos, :visible
  end

end
