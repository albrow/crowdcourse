class DynamicPagesController < ApplicationController

	before_filter :authenticate_user!, :only => [:home]

	def index
		if user_signed_in?
			@user = current_user
			render :action => 'home'
		else
			@mailing_list_member = MailingListMember.new
			render :action => 'landing'
		end
	end

	def landing
		@mailing_list_member = MailingListMember.new
	end

	def home
		@user = current_user
	end

	def learn
	end

	def teach
	end

end
