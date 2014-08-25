# == Schema Information
#
# Table name: quizzes
#
#  id            :integer         not null, primary key
#  component_id  :integer
#  flags_count   :integer         default(0)
#  avg_score     :integer
#  num_questions :integer         default(0)
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#

require 'spec_helper'

describe Quiz do
  pending "add some examples to (or delete) #{__FILE__}"
end
