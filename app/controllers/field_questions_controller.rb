class FieldQuestionsController < ApplicationController

	before_filter :authenticate_user!

	def new
		@quiz = Quiz.find(params[:quiz_id])
		@question = @quiz.field_questions.create
		flash[:blue] = "Added a new question to the quiz! Fill out the form below to edit it."
		redirect_to edit_field_question_path(@question.id)
	end

	def edit
		@question = FieldQuestion.find_by_id params[:id]
	end

	def update
		@question = FieldQuestion.find_by_id params[:id]
		@question.update_attributes params[:field_question]
		flash[:blue] = "Question updated successfully!"
		redirect_to :action => :edit
	end

	def destroy
		@question = FieldQuestion.find_by_id params[:id]
		@quiz = @question.quiz
		@question.destroy
		flash[:blue] = "The queston was deleted."
		redirect_to edit_quiz_path(@quiz.id)
	end

end
