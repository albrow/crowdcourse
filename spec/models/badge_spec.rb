# == Schema Information
#
# Table name: badges
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  description :text
#  image_large :string(255)
#  image_small :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

require 'spec_helper'

describe Badge do
  pending "add some examples to (or delete) #{__FILE__}"
end
