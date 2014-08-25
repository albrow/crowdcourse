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

class Component < ActiveRecord::Base
  attr_accessible :name, :description, :detailed_description, :priority, :alias
  attr_accessible :section_id

  ## Associations
  has_many :videos, :dependent => :destroy
  has_one :quiz, :dependent => :destroy
  belongs_to :section

  ## callbacks
  after_create :set_default_attributes


	## scopes and search...

  include PgSearch
  
  # multisearchable :against => [
  #   :name,
  #   :alias,
  #   :description,
  #   :detailed_description
  # ]

  pg_search_scope :search_full_text, :against => {
	    :name => 'A',
	    :alias => 'B',
	    :description => 'C',
	    :detailed_description => 'D'
	  }, :using => {
  	:dmetaphone => {},
    :trigram => {},
    :tsearch => {:prefix => true, :dictionary => "english", :any_word => true}
  },
  :ignoring => :accents


	scope :prioritized, :order => "priority ASC"

  
  def set_default_attributes
    if self.priority.nil?
      max_priority = self.section.components.maximum("priority")
      self.priority = (max_priority.nil? ? 1 : max_priority + 1)
      self.save
    end

    if self.name.nil?
      self.name ||= "New Lesson"
      self.save
    end
  end

	## a small hack to get the course of the lesson...
	# (sort of like a belongs_to, :through)
	def course
		return self.section.course if self.section
		return nil
	end

  def top_video
    # this syntax seems weird,
    # but blank is not the same as nil
    # and this is necessary to prevent errors
    vid = self.videos.top_rated(1).first
    if vid.blank?
      return nil
    else 
      return vid
    end
  end

  def next_component
    # find the next component in this section
    # since the priorities are not necessarily sequential,
    # we need to find the one with the next closest priority
    comps = section.components.prioritized
    index = comps.index(self)
    if comps[index + 1] != nil
      return comps[index + 1]
    else
      begin
        if section.next_section
          return section.next_section.components.prioritized.first
        else
          return nil
        end
      rescue
        return nil
      end
    end

    return nil

  end

  def previous_component
    # find the previous component in this section
    # since the priorities are not necessarily sequential,
    # we need to find the one with the previous closest priority
    comps = section.components.prioritized
    index = comps.index(self)
    if index != 0
      return comps[index -1]
    else
      begin
        if section.previous_section
          return section.previous_section.components.prioritized.last
        else
          return nil
        end
      rescue
        return nil
      end
    end

    return nil 

  end


end
