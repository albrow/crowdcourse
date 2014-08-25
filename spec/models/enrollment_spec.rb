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

require 'spec_helper'

describe Enrollment do
  pending "add some examples to (or delete) #{__FILE__}"
end
