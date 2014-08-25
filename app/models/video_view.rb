# == Schema Information
#
# Table name: video_views
#
#  id         :integer         not null, primary key
#  viewer_id  :integer
#  video_id   :integer
#  finished   :boolean
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class VideoView < ActiveRecord::Base
  
	belongs_to :viewer, class_name: "User"
	belongs_to :video

end
