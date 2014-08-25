class ChoiceQuestionsController < ApplicationController

	before_filter :authenticate_user!

	def new
		@quiz = Quiz.find(params[:quiz_id])
		@question = @quiz.choice_questions.create
		flash[:blue] = "Added a new question to the quiz! Fill out the form below to edit it."
		redirect_to edit_choice_question_path(@question.id)
	end

	def edit
		@question = ChoiceQuestion.find_by_id params[:id]
	end

	def update
		@question = ChoiceQuestion.find_by_id params[:id]
		@question.update_attributes params[:choice_question]
		flash[:blue] = "Question updated successfully!"
		redirect_to :action => :edit
	end

	def destroy
		@question = ChoiceQuestion.find_by_id params[:id]
		@quiz = @question.quiz
		@question.destroy
		flash[:blue] = "The queston was deleted."
		redirect_to edit_quiz_path(@quiz.id)
	end

end
