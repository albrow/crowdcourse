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

class QuizScore < ActiveRecord::Base
  attr_accessible :score, :quiz_id, :user_id, :video_id

  ## Associations
  belongs_to :user
  belongs_to :quiz
  belongs_to :video # the most recently watched video (used for rating the video)
end
