# == Schema Information
#
# Table name: field_questions
#
#  id          :integer         not null, primary key
#  quiz_id     :integer
#  description :text
#  answer      :text
#  field_type  :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class FieldQuestion < ActiveRecord::Base
  attr_accessible :description, :answer, :field_type, :quiz_id

  belongs_to :quiz

  def self.newest
    order("created_at DESC")
  end

  def self.by_date
    order("created_at ASC")
  end

  def self.where_ready
    all.map do |q|
      q if q.ready?
    end
  end

  def field_question?
		true
  end

  def choice_question?
		false
  end

  def ready?
    !description.blank? && !answer.blank? 
  end

  def shortened_name length=25
    # we don't want to leave any unclosed mathjax tags (`) 
    # when we shorten the name, so this takes a little work
    unless description.nil?
      name = description.truncate(length)
      ## TODO: filter out unclosed mathjax tags
    else
      return "New Question"
    end
  end
  
end
