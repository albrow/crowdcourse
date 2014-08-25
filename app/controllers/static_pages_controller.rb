class StaticPagesController < ApplicationController

	def styleTests
	end

	def about
	end

	def contact
	end

	def legal
	end

	def community_guidelines
	end

	def video_guidelines
	end

	def news
		@mailing_list_member = MailingListMember.new
	end

end
