class AddS3KeyToVideos < ActiveRecord::Migration
  def change
  	add_column :videos, :s3_key, :string
  end
end
