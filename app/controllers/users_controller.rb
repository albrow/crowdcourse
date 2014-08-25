class UsersController < ApplicationController

  before_filter :authenticate_user!, :except => :show

  def show
    @user = !params[:id].nil? ? User.find(params[:id]) : current_user
    if @user
      @videos_made = @user.videos_made.where("visible = 't'")
      
      # By default, when you view your own profile it shows everything, but
      # the option to view the profile as it would appear to another user
      # can be provided as an option in the link_to tag
      params[:as_other] ||= false
      @as_other = params[:as_other] # the class variable is used in the view

      if !params[:as_other]
        @logged_in_user = (@user == current_user)
      else
        @logged_in_user = false
      end

      # if a user is viewing his/her own profile, everything is shown
      @show_stats = @user.show_stats || @logged_in_user
      @show_activity = @user.show_activity || @logged_in_user
      @show_full_name = @user.show_full_name || @logged_in_user
      @show_email = @user.show_email || @logged_in_user
      @show_videos_made = @user.show_videos_made || @logged_in_user
      @show_donation_button = @user.accept_donations

      # an empty profile has a big gap on the right side
      # we'll fill this with some information about privacy later
      @empty_profile = !(@show_videos_made || @show_activity) && !@logged_in_user
    else
      flash[:notice] = "User not found!"
      redirect_to root_path
    end
  end

  def courses
    @user = current_user
    @courses = current_user.courses
  end

  def update_description
    @user = current_user
    des = params[:description]
    @user.update_attribute :description, des
    render :text => "true", :type => "text/json"
  end

  def update_privacy
    @user = current_user
    if @user.update_attributes params[:user]
      flash[:blue] = "Updated privacy settings!"
    else
      flash[:white] = "There was a problem."
    end
    redirect_to privacy_settings_path
  end

  def privacy_settings
    @user = current_user
    render 'settings/privacy_settings'
  end

  def update_donation_settings
    @user = current_user
    if @user.update_attributes params[:user]
      flash[:blue] = "Updated donation settings!"
    else
      flash[:white] = "There was a problem."
    end
    redirect_to donation_settings_path
  end

  def donation_settings
    @user = current_user
    render 'settings/donation_settings'
  end

  def update

  end
  
end
