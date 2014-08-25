ActiveAdmin.register ChoiceQuestion do

	menu :parent => "Quizzes"

	index do
		column :id
		column :description
		column "Quiz" do |question|
			link_to question.quiz.component.name, admin_quiz_path(question.quiz)
		end
		column :created_at
		column :updated_at

		default_actions
	end

	form do |f|

  	f.inputs "Basics" do
  		f.input :quiz, :member_label => lambda{|q| q.component.name}
      f.input :description
  	end
		
		f.has_many :choices do |c|
			c.input :content
			c.input :is_answer
		end

  	f.buttons
  end

  show do
		attributes_table do
			row :id
			row :description
			row "Quiz" do |question|
				link_to question.quiz.component.name, admin_quiz_path(question.quiz)
			end
			row "# Choices" do |question|
				question.choices.size
			end
			row "Answer" do |question|
				question.answer.content
			end
			row :created_at
			row :updated_at
		end
  end
  
end
