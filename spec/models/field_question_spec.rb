# == Schema Information
#
# Table name: field_questions
#
#  id          :integer         not null, primary key
#  quiz_id     :integer
#  description :text
#  answer      :text
#  field_type  :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

require 'spec_helper'

describe FieldQuestion do
  pending "add some examples to (or delete) #{__FILE__}"
end
