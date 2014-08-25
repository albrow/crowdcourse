class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  skip_before_filter :verify_authenticity_token

	def facebook
		user = User.from_omniauth(request.env["omniauth.auth"])
    if user.persisted?
      flash.notice = "Signed in!"
      
      # if the oauth_token is expired or nil, update it...
      if (DateTime.now > (user.oauth_expires_at || 99.years.ago) )
        user.update_oauth_token(request.env["omniauth.auth"])
      end

      sign_in_and_redirect user
    else
      session["devise.user_attributes"] = user.attributes
      redirect_to new_user_registration_url
    end
	end
end
