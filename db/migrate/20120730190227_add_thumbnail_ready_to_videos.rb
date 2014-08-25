class AddThumbnailReadyToVideos < ActiveRecord::Migration
  def change
  	add_column :videos, :thumbnail_ready, :boolean, :default => false
  end
end
