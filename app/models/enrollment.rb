# == Schema Information
#
# Table name: enrollments
#
#  id                  :integer         not null, primary key
#  course_id           :integer
#  user_id             :integer
#  progress_as_percent :integer         default(0)
#  num_videos_watched  :integer         default(0)
#  num_quizzes_passed  :integer         default(0)
#  created_at          :datetime        not null
#  updated_at          :datetime        not null
#  show                :boolean         default(TRUE)
#  last_active         :time
#

class Enrollment < ActiveRecord::Base
  attr_accessible :progress_as_percent, :num_videos_watched, :num_quizzes_passed, :course_id, :user_id

  belongs_to :user
  belongs_to :course

end
