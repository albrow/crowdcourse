# == Schema Information
#
# Table name: quiz_scores
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  quiz_id    :integer
#  score      :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  video_id   :integer
#

require 'spec_helper'

describe QuizScore do
  pending "add some examples to (or delete) #{__FILE__}"
end
