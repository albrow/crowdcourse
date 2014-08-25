# == Schema Information
#
# Table name: courses
#
#  id                                   :integer         not null, primary key
#  name                                 :string(255)
#  description                          :text
#  image_large                          :string(255)
#  image_small                          :string(255)
#  created_at                           :datetime        not null
#  updated_at                           :datetime        not null
#  priority                             :integer
#  has_sections                         :boolean         default(TRUE)
#  others_can_add_videos                :boolean         default(TRUE)
#  others_can_add_quizzes               :boolean         default(TRUE)
#  others_can_add_lessons               :boolean         default(TRUE)
#  others_can_edit_quizzes              :boolean         default(FALSE)
#  others_can_edit_lessons              :boolean         default(FALSE)
#  others_can_request_to_be_maintainers :boolean         default(TRUE)
#

class Course < ActiveRecord::Base
  attr_accessible :description, :image_large, :image_small, :name, :priority, :has_sections
  attr_accessible :enrollments_attributes, :category_ids, :section_ids

	## Associations...
  has_many :sections, :dependent => :destroy
  has_many :components, :through => :sections
  has_many :enrollments
  has_many :users, :through => :enrollments
  has_and_belongs_to_many :categories

  has_and_belongs_to_many :maintainers,
          :join_table => "courses_maintainers", :class_name => "User", :association_foreign_key => "maintainer_id"

  accepts_nested_attributes_for :enrollments, :categories, :sections

	## Validations...
	validates :name, :description, :presence => true
	validates :name, :uniqueness => true
	validates_associated :categories, :maintainers
	## TODO: check that the validations are not nil
	# might have to use a custom validator for this

	## scopes and search...
  include PgSearch
  multisearchable :against => [:name, :description]

  scope :prioritized, :order => "priority ASC"

	## TODO: fix search

	# def self.search(search)
	#   if search
	#     find(:all, :conditions => ['name LIKE ?', "%#{search}%"])
	#   else
	#     find(:all)
	#   end
	# end

	def children
		return self.components
	end

	def info_settings_path
		return "/courses/#{self.id}/settings"
	end

	def syllabus_settings_path
		return "/courses/#{self.id}/settings/syllabus"
	end

	def contributors_settings_path
		return "/courses/#{self.id}/settings/contributors"
	end

	def maintainers_settings_path
		return "/courses/#{self.id}/settings/maintainers"
	end
  
end
