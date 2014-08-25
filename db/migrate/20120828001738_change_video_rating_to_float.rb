class ChangeVideoRatingToFloat < ActiveRecord::Migration
  def change
  	remove_column :videos, :avg_rating
  	add_column :videos, :avg_rating, :float
  end
end
