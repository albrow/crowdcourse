# == Schema Information
#
# Table name: flags
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  comment_id :integer
#  video_id   :integer
#  quiz_id    :integer
#  cause      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Flag < ActiveRecord::Base
	#users can flag videos, quizzes, or comments for a variety of reasons. The reason for the flag is included as "cause".
	attr_accessible :user_id, :comment_id, :video_id, :quiz_id, :cause

	belongs_to :user
	belongs_to :comment, :counter_cache => true
	belongs_to :video, :counter_cache => true
	belongs_to :quiz, :counter_cache => true

end
