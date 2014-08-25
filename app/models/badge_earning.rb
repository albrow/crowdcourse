# == Schema Information
#
# Table name: badge_earnings
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  badge_id   :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class BadgeEarning < ActiveRecord::Base
  attr_accessible :user_id, :badge_id, :created_at

  belongs_to :user
  belongs_to :badge

end
