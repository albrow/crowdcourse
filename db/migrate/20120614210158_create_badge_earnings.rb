class CreateBadgeEarnings < ActiveRecord::Migration
  def change
    create_table :badge_earnings do |t|

    	t.integer :user_id
    	t.integer :badge_id

			# The timestamps are what's important.
			# Among other useful things, they allow us to sort badges earned by date.
			# This is why I opted for has_many through instead of habtm.
      t.timestamps
    end

    add_index :badge_earnings, :user_id
    add_index :badge_earnings, :badge_id
    add_index :badge_earnings, [:badge_id, :user_id]
  end
end
