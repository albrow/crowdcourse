class VideosController < ApplicationController

	before_filter :authenticate_user!, 
			:only => [:create_from_file, :create_from_url, :destroy, :rate]

  def index
  	@videos = Video.where("visible = 't'")
  end

	# don't think this is needed
  # def new
  # 	@video = Video.new
  # end

  def create_from_file

		@user = current_user

		if current_user.is_bot?
			current_user = User.bots.sample
		else
			# idk why this is necessary but without it current_user becomes nil
			current_user = @user
		end

		@video = Video.new
		@video.creator = current_user
		@video.component = Component.find_by_id(params[:component_id])
		@video.s3_key = params[:s3_key]
		@video.hosted = true
		@video.source = "vimeo"
		@video.save
		@video.upload # starts the bg task (uploads to vimeo)

		flash[:blue] = "Your video has been uploaded! Please allow some time for processing."

		render :type => "text/javascript", :text => "#{@video.id}"
		
  end

  def create_from_url
  	source = get_source_from_url params[:video][:embed_url]
		if source

			@user = current_user

			if current_user.is_bot?
				current_user = User.bots.sample
			else
				# idk why this is necessary but without it current_user becomes nil
				current_user = @user
			end

	  	args = {}
			args[:embed_url] = params[:video][:embed_url]
	  	args[:component_id] = params[:video][:component_id]
			vid = Video.new args
			vid.creator = current_user
			vid.source = source
			vid.ready = true
			vid.hosted = false

			# make sure the url is the right format for 
			# embedding if it's a vimeo url
			if source == "vimeo"
	  		vim_id = vid.vimeo_id
	  		new_url = "http://player.vimeo.com/video/#{vim_id}"
	  		vid.embed_url = new_url
	  	end
			vid.save
			vid.update_thumbnails
			vid.update_duration

			# # add to the user's points
	    current_user.points += 10
	    current_user.save

	    # # create an activity for the user's profile
	    act = current_user.activities.build
	    act.kind = "created_video"
	    act.data = {:video_id => vid.id, :points => 10}
	    act.save

			flash[:blue] = "Video added successfully!"
			redirect_to vid


		else # the url was invalid
			flash[:blue] = "There was a problem. Did you provide a valid url?"
			redirect_to Component.find(params[:video][:component_id])

		end

	end

	def get_source_from_url url

		return nil if url.blank?

		unless (url.include?("http://") || url.include?("https://"))
			return nil
		end

		if url.include? "vimeo.com"
			return "vimeo"

		elsif (url.include?("youtube.com") || url.include?("youtu.be"))
			return "youtube"

		else
			return nil

		end
		
	end

  def show
  	#@video = Video.find_by_id(params[:id])
  	@video = Video.includes(:component => {:section => {:course => :categories}}).find_by_id(params[:id])

  	if @video == nil
			flash[:purple] = "Sorry, we couldn't find a video with id of #{params[:id]}. It may have been removed."
			redirect_to root_path
			return
  	end
		
		if !@video.visible?
			flash[:purple] = "Sorry, that video has been removed by its creator."
			redirect_to root_path
			return
		end

		if !@video.is_ready?
			# schedule a background task to check readiness...
			@video.delayed_check_ready
			puts "-- -- Scheduling a bg task to check if video ##{@video.id} is ready."
		end
		
  end

  def destroy
		
  	@video = Video.find(params[:id])

  	unless (current_user.id == @video.creator.id)
  		# if the user is trying to delete a video they don't own...
  		flash['purple'] = "You don't have permissions to do that!"
  		redirect_to @video
  		return
  	end

		if @video

			if @video.hosted
			
				##
				#	for videos hosted on our vimeo account,
				# we want to remove the video from vimeo
				#

				# Access config vars defined in config/config.yml: APP_CONFIG['key']
		  	c_key = APP_CONFIG['vimeo_consumer_key']
		  	c_sec = APP_CONFIG['vimeo_consumer_secret']
		  	a_key = APP_CONFIG['vimeo_access_token']
		  	a_secret = APP_CONFIG['vimeo_access_secret']
				
				begin
					vimeo_video = Vimeo::Advanced::Video.new(c_key, c_sec, :token => a_key, :secret => a_secret)
				rescue
					flash[:purple] = "Sorry, our video servers seem to be down. Please try again later."
			  	redirect_to @video
			  	return
				end

				begin
					vimeo_id = @video.vimeo_id
					vimeo_video.delete(vimeo_id)
				rescue
					flash[:purple] = "Sorry, there was a problem connecting to our servers. Please try again later."
			  	redirect_to @video
			  	return
			  end

			end

	  	@video.update_attributes :visible => false

			flash[:blue] = "Video deleted!"
			
			if @video.hosted?
				points = 25
			else
				points = 10
			end

			current_user.points -= points
			current_user.save

			# add an activity for the user
			act = current_user.activities.build
			act.kind = "removed_video"
			act.data = {:video_id => @video.id, :points => points}
			act.save

			redirect_to @video.component

		else
			flash[:purple] = "That video does not exist."
			redirect_to root_path
		end
		
  end

  def video_view
		# add a VideoView (used for activity tracking and algorithmic rating)

		@video = Video.find_by_id(params[:video_id])
		view = nil

		if current_user

			@user = current_user

			if current_user.is_bot?
				current_user = User.bots.sample
			else
				# idk why this is necessary but without it current_user becomes nil
				current_user = @user
			end

	  	view = current_user.video_views.create
	  	view.video = @video
			view.finished = false
			view.save
		else
			view = @video.views.build
			view.finished = false
			view.save
		end

		if view
			# return the view id so it can be used by the js later
			render :text => view.id, :type => "text/javascript"
		end

  end

  def video_view_complete
		# called by javascript when a user finishes watching a video
		@video = Video.find_by_id(params[:video_id])
		@view = VideoView.find_by_id(params[:view_id])
		if current_user

			@user = current_user

			if current_user.is_bot?
				current_user = User.bots.sample
			else
				# idk why this is necessary but without it current_user becomes nil
				current_user = @user
			end

			# add an activity
			first_time = !(current_user.has_watched? @video.id)
			act = current_user.activities.build
			act.kind = "watched_video"
			act.data = {:video_id => @video.id, :first_time => first_time }
			act.save

			# update user points
			if first_time
				current_user.points += 3
				current_user.save
			end

		end

		if @view
			@view.finished = true
			@view.save
		end

		render :nothing => true

  end

  def rate

		# called by javascript when a user rates a video
		vid = Video.find(params[:video_id])
		rating_value = params[:value]
		if !current_user.nil?
			
			# I have absolutely no idea why this is necessary, but if you
			# remove this line it sets the current_user to nil and throws an error
			@user = current_user

			if current_user.is_bot?
				current_user = User.bots.sample
			else
				# see note above, this fixes an impossibly strange error
				current_user = @user
			end

			raise "oh fucking shit fuck!" if current_user.nil?

			if VideoRating.where(:rater_id => current_user.id, :video_id => vid.id).exists?
				response = {:success => false, :reason => "You already rated this!"}
				render :json => response
				return
			end

			# create and save the model
			rat = current_user.video_ratings.build
			rat.value = rating_value
			rat.video = vid
			rat.save

			# add to num_ratings
			vid.num_ratings += 1
			vid.save

			# create an activity for the user
			act = current_user.activities.build
			act.kind = "rated_video"
			act.data = {:video_id => vid.id, :rating_value => rating_value}
			act.save

			# update user points
			current_user.points += 3
			current_user.save

			
			# return some json, which will be interpretted by js to update the view
			response = {:success => true, :rating => rating_value}
			render :json => response

		else

			# return an error message if the user is not logged in
			response = {:success => false, :reason => "You must login first."}
			render :json => response
			
		end
  end

  private

  	def is_video?(file)
			# check if the file is a video
			# do some fast checks first
			begin
				valid = false
				
				if file.nil?
					puts "WARNING! file was nil! ---------------"
					return valid
				end

				type = file.content_type
				name = file.original_filename
				

				# check mimetype
		  	valid_mime_type = type.include?("video")
				return true if valid_mime_type

				puts "File name = #{name}"
				
				# check extension name
		  	valid_extensions = [ ".avi", ".mov", ".mkv", ".mp4", ".mpg", ".wmv", ".3gp", ".asf", ".rm" ]
				valid_extensions.each  do |ext|
					valid = true if name.include? ext
				end
				return valid

				# TODO: longer, failproof check

			rescue
				return false

			end
			
		end

end
