class AddDescriptionToUsers < ActiveRecord::Migration
  def change
  	change_table :users do |t|
			t.text :description
  	end
  end
end
