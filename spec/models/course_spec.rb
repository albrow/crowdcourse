# == Schema Information
#
# Table name: courses
#
#  id                                   :integer         not null, primary key
#  name                                 :string(255)
#  description                          :text
#  image_large                          :string(255)
#  image_small                          :string(255)
#  created_at                           :datetime        not null
#  updated_at                           :datetime        not null
#  priority                             :integer
#  has_sections                         :boolean         default(TRUE)
#  others_can_add_videos                :boolean         default(TRUE)
#  others_can_add_quizzes               :boolean         default(TRUE)
#  others_can_add_lessons               :boolean         default(TRUE)
#  others_can_edit_quizzes              :boolean         default(FALSE)
#  others_can_edit_lessons              :boolean         default(FALSE)
#  others_can_request_to_be_maintainers :boolean         default(TRUE)
#

require 'spec_helper'

describe Course do
  pending "add some examples to (or delete) #{__FILE__}"
end
