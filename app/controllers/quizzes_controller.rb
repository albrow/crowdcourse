class QuizzesController < ApplicationController

	before_filter :authenticate_user!, :only => [:edit, :update, :destroy]

	def index
		@quizzes = Quiz.all
	end

	def show
		@quiz = Quiz.find(params[:id])
		@questions = @quiz.questions.shuffle
		@first_question = @questions.first
	end

	def new
		@component = Component.find_by_id(params[:component_id])

		if @component.quiz
			redirect_to edit_quiz_path(@component.quiz.id)
		end

		if @component.nil?
			flash[:blue] = "We couldn't find that lesson :("
			redirect_to root_path
			return
		end
		@quiz = Quiz.new
		@quiz.component = @component
		@quiz.save
	end

	def edit
		@quiz ||= Quiz.find_by_id params[:id]

		if @quiz.nil?
			flash[:blue] = "We couldn't find that quiz :("
			redirect_to root_path
			return
		end

		@component ||= @quiz.component
		if @component.nil?
			flash[:blue] = "We couldn't find that lesson :("
			redirect_to root_path
			return
		end
	end

	def update

	end

	def destroy

	end

	def get_questions

		# This is used in an ajax call to return an array of questions and choices.
		# Javascript is then used to display this information.
		
		quiz = Quiz.find(params[:id])
		questions = quiz.randomized_questions(5)
		questions_and_choices = [];

		questions.each do |q|
			unless q.nil?
				if q.choice_question?
					choices = q.choices.shuffle.collect {|c| {:id => c.id, :content => c.content}}
					questions_and_choices << {:id => q.id, :type => "choice", :description => q.description, :answer_id => q.answer.id, :choices => choices }
				else
					questions_and_choices << {:id => q.id, :type => "field", :description => q.description, :answer => q.answer}
				end
			end
		end

		json = ActiveSupport::JSON
		render :text => json.encode(questions_and_choices), :content_type => "text/javascript"

	end

	def complete_quiz
		## this is an Ajax method called when the javascript quiz taker is over

		@quiz = Quiz.find(params[:id])
		@score = params[:score]


		if current_user

			@user = current_user

			if current_user.is_bot?
				current_user = User.bots.sample
			else
				# idk why this is necessary but without it current_user becomes nil
				current_user = @user
			end
			
			# update user points
			@points_earned = 0
			old_max = current_user.quiz_scores.where("quiz_id = ?", @quiz.id).maximum("score")
			if !old_max.nil?
				if @score.to_i > old_max
					current_user.points -= (old_max / 20)
					current_user.points += (@score.to_i / 20)
					current_user.save
					@points_earned = (@score.to_i / 20) - (old_max / 20)
				end
			else
				current_user.points += (@score.to_i / 20)
				current_user.save
				@points_earned = (@score.to_i / 20)
			end

			render :text => render_to_string(:partial => 'complete_quiz')

			# update the database
			q_score = current_user.quiz_scores.create
			q_score.score = @score
			q_score.quiz = @quiz

			# we need to figure out which video to attribute the quiz to (for ranking algorithm)
			# assume that it was the most recently watched
			component = @quiz.component
			most_recent_video = current_user.videos_viewed.where("component_id = ?", component.id).first
			q_score.video = most_recent_video

			q_score.save

			# update the avg_quiz_score for that video (used for rating)
			if most_recent_video
				avg_score = most_recent_video.quiz_scores.average(:score).to_i
				most_recent_video.update_attribute :avg_quiz_score, avg_score
			end

			# update the user's avg_quiz_score
			current_user.avg_quiz_score = current_user.quiz_scores.average("score").to_i
			current_user.save

			# create an activity
			act = current_user.activities.build
			act.kind = "took_quiz"
			act.data = {:quiz_id => @quiz.id, :score => @score, :points => @points_earned}
			act.save
		else
		
		render :text => render_to_string(:partial => 'complete_quiz')

		end

	end

end
