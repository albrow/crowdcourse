## "type" is reserved by rails, so I've decided to rename it to "kind"
# I did the same thing in the activity model for consistency.

class RenameTypeToKindInVideos < ActiveRecord::Migration
  def up
  	rename_column :videos, :type, :kind
  end

  def down
  	rename_column :videos, :kind, :type
  end
end
