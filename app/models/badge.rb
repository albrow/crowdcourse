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

class Badge < ActiveRecord::Base
  attr_accessible :name, :description, :image_large, :image_small, :badge_earnings_attributes

  has_many :badge_earnings
  has_many :users, :through => :badge_earnings

  accepts_nested_attributes_for :badge_earnings

end
