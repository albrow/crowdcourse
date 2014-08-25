# == Schema Information
#
# Table name: categories
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  description :text
#  image_large :string(255)
#  image_small :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class Category < ActiveRecord::Base
  attr_accessible :name, :description, :image_small, :image_large, :course_ids

	has_and_belongs_to_many :courses
  accepts_nested_attributes_for :courses
	
	## Validations
	validates :name, :presence => true, :uniqueness => true

	## scopes and search...
	
	include PgSearch
  multisearchable :against => [:name, :description]

  def children
		return self.courses
  end

end
