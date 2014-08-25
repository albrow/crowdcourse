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

class MailingListMember < ActiveRecord::Base
  attr_accessible :email, :last_sent

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, :uniqueness => :true, format: { with: VALID_EMAIL_REGEX }
end
