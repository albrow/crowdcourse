class AddBotsAttributeToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :is_bot, :boolean, :default => false
  end
end
