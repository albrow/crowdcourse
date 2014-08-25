# == Schema Information
#
# Table name: activities
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  kind       :string(255)
#  data       :text
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe Activity do
  pending "add some examples to (or delete) #{__FILE__}"
end
