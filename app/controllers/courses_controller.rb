class CoursesController < ApplicationController

	before_filter :authenticate_user!, :except => [:index, :show]

	def index
		@courses = Course.all
		if !@courses.empty?

			## 
			# We need to search through each course to find out which categories are present.
			# The following code retrieves a set of categories for which there are courses in the search results
			# There is only one occurence of each category
			# This way we can sort the search results by category.

			@categories = @courses.inject(@courses.first.categories) {|result, course| result = result | course.categories}

		else
			@categories = []
		end
	end

	def show
		@course = Course.find_by_id(params[:id])
		if @course.nil?
			flash[:blue] = "That course does not exist or has been removed!"
			redirect_to root_path
			return
		end
		@term = params[:search]
  	# @components = Component.search(@term, @course) TODO: fix search
  	@components = @course.components.prioritized
  	@sections = @course.sections.prioritized
  	@show_admin_options = @course.maintainers.include? current_user
  end

  def new
  	@course ||= Course.new
  	@category ||= Category.new
  	@category_options = category_options_for (c = @course)
  end

  def create

  	@course = Course.new params[:course]

		##
		# the params include the category_id of an existing category.
		# if the user elects to create a new category, the 
		# category_id is -1, which means find_by_id will be nil
		@category = Category.find_by_id(params[:category_id])
		if !@category
			@category = Category.create :name => params[:category_name]
		end

		if !@category.valid?
			error_during_create
			return
		end

		@course.save
		if !@course.valid?
			error_during_create
			return
		end
		@course.categories << @category

		##
		# if there is no priority provided, we have to 
		# set one. The default is simply to place the new
		# course after the last course in the category...
		if params[:course][:priority].blank?
			max_priority = @category.courses.maximum("priority")
			@course.priority = max_priority ? max_priority + 1 : 1
		end

		@course.maintainers << current_user

		@course.save
		redirect_to @course
	end

	def update

		@course = Course.find_by_id(params[:id])
		authenticate_as_maintainer @course

		##
		# the params include the category_id of an existing category.
		# if the user elects to create a new category, the 
		# category_id is -1, which means find_by_id will be nil
		@category = Category.find_by_id(params[:category_id])
		if !@category
			@category = Category.create :name => params[:category_name]
		end

		if !@category.valid?
			error_during_update
			return
		end

		@course.update_attributes params[:course]
		if !@course.valid?
			error_during_update
			return
		end
		@course.categories.clear
		@course.categories << @category
		@course.save

		##
		# if there is no priority provided, we have to 
		# set one. The default is simply to place the new
		# course after the last course in the category...
		if params[:course][:priority].blank?
			max_priority = @category.courses.maximum("priority")
			@course.priority = max_priority ? max_priority + 1 : 1
		end

		@category_options = category_options_for (c = @course)
		@selected_category = @course.categories.first.id

		redirect_to @course.info_settings_path
	end

	def info_settings
		@course = Course.find(params[:id])
		authenticate_as_maintainer @course
		@category = @course.categories.first
		@category_options = category_options_for (c = @course)
		@selected_category = @course.categories.first.id
	end

	def syllabus_settings
		@course = Course.find(params[:id])
		authenticate_as_maintainer @course
	end

	def contributors_settings
		@course = Course.find(params[:id])
		authenticate_as_maintainer @course
	end

	def maintainers_settings
		@course = Course.find(params[:id])
		authenticate_as_maintainer @course
		require 'json'
		@usernames = User.all_usernames.to_json
	end

	def destroy_with_confirmation
		@course = Course.find(params[:course_id])
		authenticate_as_maintainer @course
		if @course.name == params[:course_confirm_name]
			@course.destroy
			flash[:blue] = "The course has been destroyed."
			redirect_to root_path
			return
		else
			flash[:blue] = "The course name you entered did not match. Please try again."
			redirect_to @course.info_settings_path
			return
		end
	end

	def add_maintainer
		@course = Course.find(params[:course_id])
		authenticate_as_maintainer @course
		if params[:username].blank?
			flash[:blue] = "Please enter a valid username and then press \"add\""
			redirect_to @course.maintainers_settings_path
			return
		end
		@user = User.find_by_username(params[:username])
		if @user.nil?
			flash[:blue] = "The username #{params[:username]} does not exist. Did you make a typo?"
			redirect_to @course.maintainers_settings_path
			return
		elsif @course.maintainers.include? @user
			flash[:blue] = "#{@user.username} is already a maintainer for this course!"
			redirect_to @course.maintainers_settings_path
			return
		else
			@course.maintainers << @user
			flash[:blue] = "#{@user.username} has been added as a maintainer!"
			redirect_to @course.maintainers_settings_path
			return
		end
	end

	private

	def authenticate_as_maintainer(course)
		unless course.maintainers.include? current_user
			flash[:blue] = "You don't have permission to do that!"
			redirect_to course
			return
		end
	end

	def category_options_for (c = @course)
		options = Array.new
		Category.all.collect do |cat| 
			options << [cat.name, cat.id]
		end
		options << ["Create new Category", -1]
	end

	def error_during_create
		@course ||= Course.new
		@category ||= Category.new
		@category_options = category_options_for (c = @course)
		if !@course.categories.empty?
			@selected_category = @course.categories.first.id
		end
		flash[:blue] = "There were some problems with the information you submitted (see below for details)."
		render 'courses/new'
	end

	def error_during_update
		@course ||= Course.find_by_id(params[:id])
		@category ||= @course.category
		@category_options = category_options_for (c = @course)
		if !@course.categories.empty?
			@selected_category = @course.categories.first.id
		end
		flash[:blue] = "There were some problems with the information you submitted (see below for details)."
		render 'courses/info_settings'
	end

end
