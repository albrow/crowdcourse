# == Schema Information
#
# Table name: choice_questions
#
#  id          :integer         not null, primary key
#  quiz_id     :integer
#  description :text
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class ChoiceQuestion < ActiveRecord::Base
  attr_accessible :description, :quiz_id, :choices_attributes

	belongs_to :quiz
	has_many :choices, class_name: "QuizChoice", foreign_key: "question_id", :dependent => :destroy

	accepts_nested_attributes_for :choices

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

	def answer
		self.choices.each {|c| return c if c.is_answer}
		return nil
	end

	def field_question?
		false
  end

  def choice_question?
		true
  end

  def ready?
  	# if there are at least 2 choices and one of them is the answer
		choices.size >= 2 && answer
  end

  def shortened_name length=25
  	unless description.nil?
			return description.truncate(length)
		else
			return "New Question"
		end
  end

end
