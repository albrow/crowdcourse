class CommentsController < ApplicationController

  before_filter :authenticate_user!

	# this is an ajax method
  def create

  	authenticate_user!
  	@comment = Comment.create(params[:comment])

    @user = current_user

    if current_user.is_bot?
      current_user = User.bots.sample
    else
      # idk why this is necessary but without it current_user becomes nil
      current_user = @user
    end
    
    @comment.user = current_user
    @comment.save

  	# add an activity
  	current_user.activities.create(:kind => "added_comment", :data => {:comment_id => @comment.id})

  	# add to the user's points
  	current_user.points += 1
  	current_user.save
		
		flash[:blue] = "Comment added (+1 point)."
		redirect_to @comment.video

  end

  def destroy
		@comment = Comment.find_by_id(params[:id])
		@comment.update_attributes(:visible => false)

  	# add to the user's points
  	current_user.points -= 1
  	current_user.save

		flash[:blue] = "Comment deleted (-1 point)."
		redirect_to @comment.video
  end

end
