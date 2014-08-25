class QuizChoicesController < ApplicationController
  
  before_filter :authenticate_user!
  
  def create
  	@question = ChoiceQuestion.find_by_id(params[:question_id])
		@choice = @question.choices.create
		response = render_to_string :partial => 'edit_form'
		render :text => response, :type => "text/html"
  end

  def edit
  end

  def update
  	@choice = QuizChoice.find_by_id(params[:id])
  	@choice.update_attributes params[:quiz_choice]
  	render :text => "true", :type => "text/javascript"
  end

  def destroy
		@choice = QuizChoice.find_by_id(params[:id])
		@choice.destroy
		render :text => "true", :type => "text/javascript"
  end
end
