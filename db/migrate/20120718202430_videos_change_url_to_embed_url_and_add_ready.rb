class VideosChangeUrlToEmbedUrlAndAddReady < ActiveRecord::Migration

	# decided to rename :url to :embed_url to remove a possible conflict

  def up
  	remove_index :videos, :url
  	remove_column :videos, :url

  	add_column :videos, :embed_url, :string
  	add_index :videos, :embed_url

  	add_column :videos, :ready, :boolean, :default => false
  end

  def down
  	remove_column :videos, :ready

  	remove_index :videos, :embed_url
  	remove_column :videos, :embed_url

  	add_column :videos, :url, :string
  	add_index :videos, :url
  end
end
