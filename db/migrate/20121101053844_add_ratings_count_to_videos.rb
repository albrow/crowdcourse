class AddRatingsCountToVideos < ActiveRecord::Migration
  def up
		add_column :videos, :num_ratings, :integer, :default => 0

		## count all the ratings for existing videos...
		Video.all.each do |v|
			v.num_ratings = v.ratings.count
			v.save
		end


  end

  def down
		remove_column :videos, :num_ratings
  end
end
