# == Schema Information
#
# Table name: components
#
#  id                   :integer         not null, primary key
#  name                 :string(255)
#  description          :string(255)
#  created_at           :datetime        not null
#  updated_at           :datetime        not null
#  priority             :integer
#  alias                :string(255)
#  section_id           :integer
#  detailed_description :text
#

require 'spec_helper'

describe Component do
  pending "add some examples to (or delete) #{__FILE__}"
end
