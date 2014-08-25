class RegistrationsController < Devise::RegistrationsController
  def update
    unless @user.last_sign_in_at.nil?

      puts "--------------double checking whether password confirmation is required--"
      ## if the user has not signed in yet, we don't want to do this.

      @user = User.find(current_user.id)
      # uncomment if you want to require password for email change
      email_changed = @user.email != params[:user][:email]
      password_changed = !params[:user][:password].empty?
      
      # uncomment if you want to require password for email change
      # successfully_updated = if email_changed or password_changed
      
      successfully_updated = if password_changed
        params[:user].delete(:current_password) if params[:user][:current_password].blank?
        @user.update_with_password(params[:user])
      else
        params[:user].delete(:current_password)
        @user.update_without_password(params[:user])
      end

      if successfully_updated
        # Sign in the user bypassing validation in case his password changed
        sign_in @user, :bypass => true
        if email_changed
          flash[:blue] = "Your account has been updated! Check your email to confirm your new address. Until then, your email will remain unchanged."
        else
          flash[:blue] = "Account info has been updated!"
        end
        redirect_to edit_user_registration_path
      else
        render "edit"
      end
    end
  end
end