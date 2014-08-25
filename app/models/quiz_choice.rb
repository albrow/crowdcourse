# == Schema Information
#
# Table name: quiz_choices
#
#  id          :integer         not null, primary key
#  question_id :integer
#  content     :text
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  is_answer   :boolean         default(FALSE)
#

class QuizChoice < ActiveRecord::Base
  attr_accessible :content, :question_id, :is_answer

	belongs_to :question, class_name: "ChoiceQuestion", foreign_key: "question_id"

	def self.by_date
		order("created_at ASC")
	end

end
