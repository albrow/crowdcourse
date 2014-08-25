# == Schema Information
#
# Table name: video_ratings
#
#  id         :integer         not null, primary key
#  video_id   :integer
#  rater_id   :integer
#  value      :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe VideoRating do
  pending "add some examples to (or delete) #{__FILE__}"
end
