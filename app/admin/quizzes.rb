ActiveAdmin.register Quiz do

	menu :label => "Quiz List", :parent => "Quizzes"

	index do
		column :id
		column :avg_score
		column "Component" do |quiz|
			link_to quiz.component.name, admin_component_path(quiz.component)
		end
		column :created_at
		column :updated_at

		default_actions
	end

  form do |f|

  	f.inputs "Basics" do
      f.input :component
  	end

    f.inputs "Questions" do

	    f.has_many :field_questions do |fq|
				fq.inputs :answer, :description
	    end

	    f.has_many :choice_questions do |cq|
	    	cq.input :description
	    end

	  end

  	f.buttons
  end
end
