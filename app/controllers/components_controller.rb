class ComponentsController < ApplicationController

	before_filter :authenticate_user!, :except => [:show]

	def show
		@component = Component.find_by_id(params[:id])
		if @component.nil?
			flash[:blue] = "That lesson does not exist or has been removed!"
			redirect_to root_path
			return
		end
		@show_admin_options = @component.course.maintainers.include? current_user
	end

	def update
		@component = Component.find_by_id(params[:id])
		@component.update_attributes(params[:component])
		render :text => "true", :type => "text/javascript"
	end

	def create
		@component = Component.new
		@component.section = Section.find_by_id params[:section_id]
		@component.save
		response = render_to_string :partial => 'components/editable_component', :component => @component
		render :text => response, :type => "text/html"
	end

	def sort
		params[:component].each_with_index do |id, index|
			Component.update_all({priority: index+1}, {id: id})
		end
	  render :text => "true", :type => "text/javascript"
	end

	def destroy
		comp = Component.find_by_id(params[:id])
		comp.destroy
		render :text => "true", :type => "text/javascript"
	end

	def change_section
		comp = Component.find_by_id(params[:component_id])
		sec = Section.find_by_id(params[:section_id])
		comp.section = sec
		comp.save
		render :text => "true", :type => "text/javascript"
	end

end
