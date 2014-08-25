class MailingListMembersController < ApplicationController
  def new
  end

  def create
  	email = params[:email]
  	if email.blank?
  		render :layout => false
			return
  	end

  	if !(email =~ /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i)
			render :layout => false
			return
  	end
  	
  	temp = MailingListMember.create(:email => email)
  	if temp.created_at
  		render :text => "true", :type => "text/javascript"
  	else
			render :text => "false", :type => "text/javascript"
  	end
  end

end
