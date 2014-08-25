# == Schema Information
#
# Table name: mailing_list_members
#
#  id         :integer         not null, primary key
#  email      :string(255)
#  last_sent  :date
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe MailingListMember do
  pending "add some examples to (or delete) #{__FILE__}"
end
