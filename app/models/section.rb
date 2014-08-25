# == Schema Information
#
# Table name: sections
#
#  id         :integer         not null, primary key
#  course_id  :integer
#  name       :string(255)
#  priority   :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Section < ActiveRecord::Base
  attr_accessible :name, :priority, :course_id

  scope :prioritized, :order => "priority ASC"

  # associations
  belongs_to :course
  has_many :components, :dependent => :destroy

  ## callbacks
  after_save :set_default_attributes

  def set_default_attributes
    if self.priority.nil?
      max_priority = self.course.sections.maximum("priority")
      priority = (max_priority.nil? ? 1 : max_priority + 1)
      self.update_attributes(:priority => priority)
    end

    if self.name.nil?
      self.name ||= "New Section"
      self.save
    end
  end

	def children
		return self.components
	end

	def next_section
    # find the next component in this section
    # since the priorities are not necessarily sequential,
    # we need to find the one with the next closest priority
    secs = course.sections.prioritized
    index = secs.index(self)
    return secs[index + 1]
  end

  def previous_section
    # find the previous component in this section
    # since the priorities are not necessarily sequential,
    # we need to find the one with the previous closest priority
    secs = course.sections.prioritized
    index = secs.index(self)
    return nil if index == 0
    return secs[index - 1]
  end

end
