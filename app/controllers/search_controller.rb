class SearchController < ApplicationController

  def index
  	
		# A simple, brute-force search
		# The basic approach is to go through each model and search by name or description
		# The resulting array contains a few different types of models (videos, courses, etc.), 
		# so it needs to be rendered carefully.

		@query = ""
		@results = []

		if params[:search]
			@query = params[:search][:query]
			if !@query.blank?
				# @results = Array.new
				# @results << Category.where("LOWER(name) LIKE LOWER(?) OR LOWER(description) LIKE LOWER(?)", "%#{@query}%", "%#{@query}%")
				# @results << Course.where("LOWER(name) LIKE LOWER(?) OR LOWER(description) LIKE LOWER(?)", "%#{@query}%", "%#{@query}%")
				# @results << Component.where("LOWER(name) LIKE LOWER(?) OR LOWER(description) LIKE LOWER(?) OR LOWER(alias) LIKE ?", "%#{@query}%", "%#{@query}%", "%#{@query}%")
				# @results << User.where("LOWER(username) LIKE LOWER(?)", "%#{@query}%")
				# @results = @results.flatten.to_set
				
				@components = Component.search_full_text(@query) # lessons are weighted, which isn't allowed in multisearch
				@other_results = PgSearch.multisearch(@query)
			end
		end

  end


end