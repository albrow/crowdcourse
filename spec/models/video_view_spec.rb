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

require 'spec_helper'

describe VideoView do
  pending "add some examples to (or delete) #{__FILE__}"
end
