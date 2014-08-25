# == Schema Information
#
# Table name: sections
#
#  id         :integer         not null, primary key
#  course_id  :integer
#  name       :string(255)
#  priority   :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe Section do
  pending "add some examples to (or delete) #{__FILE__}"
end
