class SectionsController < ApplicationController

	before_filter :authenticate_user!

	def update
		@section = Section.find_by_id(params[:id])
		@section.update_attributes(params[:section])
		render :text => "true", :type => "text/javascript"
	end

	def create
		## TODO: Return a partial template for the section
		@section = Section.new
		@section.course = Course.find_by_id params[:course_id]
		@section.name = "New Section"
		@section.save
		response = render_to_string :partial => 'sections/section_for_editable_components'
		render :text => response, :type => "text/html"
	end

	def destroy
		sec = Section.find_by_id(params[:id])
		sec.destroy
		render :text => "true", :type => "text/javascript"
	end

end
