# == Schema Information
#
# Table name: quiz_choices
#
#  id          :integer         not null, primary key
#  question_id :integer
#  content     :text
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  is_answer   :boolean         default(FALSE)
#

require 'spec_helper'

describe QuizChoice do
  pending "add some examples to (or delete) #{__FILE__}"
end
