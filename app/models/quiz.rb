# == Schema Information
#
# Table name: quizzes
#
#  id            :integer         not null, primary key
#  component_id  :integer
#  flags_count   :integer         default(0)
#  avg_score     :integer
#  num_questions :integer         default(0)
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#

class Quiz < ActiveRecord::Base
	attr_accessible :avg_score, :num_questions, :choice_questions_attributes, :field_questions_attributes, :component_id

  ## Associations
  belongs_to :component
  has_many :quiz_scores
  has_many :users_taken, class_name: "User", foreign_key: "user_id", through: :quiz_scores, source: :user
  has_many :comments
  has_many :users_commented, through: :comments, source: :user
  has_many :choice_questions, :dependent => :destroy
  has_many :field_questions, :dependent => :destroy
  has_many :flags

  accepts_nested_attributes_for :choice_questions, :field_questions

  def questions
  	self.choice_questions | self.field_questions
  end

  def questions_where_ready
    self.choice_questions.where_ready | self.field_questions.where_ready
  end

  def randomized_questions (limit=5)
    (self.choice_questions.where_ready | self.field_questions.where_ready).shuffle[0..(limit-1)]
  end

  def ready?
    questions_where_ready.size >= 4
	end

end
