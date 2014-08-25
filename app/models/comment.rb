# == Schema Information
#
# Table name: comments
#
#  id          :integer         not null, primary key
#  user_id     :integer
#  video_id    :integer
#  quiz_id     :integer
#  flags_count :integer         default(0)
#  content     :text
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  visible     :boolean         default(TRUE)
#

class Comment < ActiveRecord::Base
  attr_accessible :content, :visible
  attr_accessible :user_id, :video_id, :quiz_id

	belongs_to :user
	belongs_to :quiz
	belongs_to :video
	has_many :flags

	accepts_nested_attributes_for :flags

	scope :by_date, :order => "created_at DESC"
	scope :where_visible, where(:visible => true)

end
