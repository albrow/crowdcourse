# == Schema Information
#
# Table name: comments
#
#  id          :integer         not null, primary key
#  user_id     :integer
#  video_id    :integer
#  quiz_id     :integer
#  flags_count :integer         default(0)
#  content     :text
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  visible     :boolean         default(TRUE)
#

require 'spec_helper'

describe Comment do
  pending "add some examples to (or delete) #{__FILE__}"
end
