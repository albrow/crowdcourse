class ApplicationController < ActionController::Base
  protect_from_forgery

  def robots
	  robots = File.read(Rails.root + "config/robots.#{Rails.env}.txt")
	  render :text => robots, :layout => false, :content_type => "text/plain"
	end

	def after_sign_in_path_for(resource)                                                                                                                      
    sign_in_url = url_for(:action => 'new', :controller => 'devise/sessions', :only_path => false, :protocol => 'http')                                            
    if request.referer == sign_in_url                                                                                                                    
      super                                                                                                                                                 
    else                                                                                                                                                    
      request.referer || stored_location_for(resource) || root_path                                                                                         
    end                                                                                                                                                     
  end 

  def teapot
    # Just implementng part of the official http error spec here...
    render :status => 418, :text => "<h1>Http Error: 418 &#x2615;</h1>".html_safe
  end

end
