class MakeActivitiesForAccountCreated < ActiveRecord::Migration
  def up

		# users created before this time need to be updated
   	# to to include a created_account activity
   	cutoff_date = Time.utc(2012, "oct", 11)
  	User.all.each do |u|
      if u.created_at < cutoff_date
				u.account_created
      end
  	end

  end

  def down

  	cutoff_date = Time.utc(2012, "oct", 11)
  	User.all.each do |u|
      if u.created_at < cutoff_date
				if !u.activities.where(:kind => "created_account").blank?
					u.activities.where(:kind => "created_account").first.destroy

					u.points -= 50
					u.save
				end
      end
  	end

  end

end
