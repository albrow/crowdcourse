class AddSettingsToUsers < ActiveRecord::Migration
  def up
  	change_table :users do |t|
    	t.boolean :accept_donations, :default => false
			t.boolean :show_email, :default => false
			t.boolean :show_full_name, :default => false
			t.boolean :show_profile, :default => true
			t.boolean :show_activity, :default => true
			t.boolean :show_videos_made, :default => true
			t.boolean :show_stats, :default => true
  	end
  end

  def down
		remove_column :users, :show_stats
		remove_column :users, :show_videos_made
		remove_column :users, :show_activity
		remove_column :users, :show_profile
		remove_column :users, :show_full_name
		remove_column :users, :show_email
		remove_column :users, :accept_donations
  end
end
