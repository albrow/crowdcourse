# == Schema Information
#
# Table name: video_ratings
#
#  id         :integer         not null, primary key
#  video_id   :integer
#  rater_id   :integer
#  value      :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class VideoRating < ActiveRecord::Base
  attr_accessible :value

  belongs_to :rater, class_name: "User"
  belongs_to :video

  after_commit :update_rating

	def update_rating
		# update the avg_rating of the video (for speed this value is stored in db)
		self.video.update_rating
	end

	def destroy
	  run_callbacks :destroy do
	  	# store the video id so we can retrieve it later
	    video_id = self.video.id

	    # destroy the record and it's associations 
	    # (based on source code for default rails destroy)
	    # http://ar.rubyonrails.org/
	    unless new_record?
	    	connection.delete "DELETE FROM #{self.class.quoted_table_name}\nWHERE #{connection.quote_column_name(self.class.primary_key)} = #{quoted_id}\n", "#{self.class.name} Destroy"
	    end
	    freeze

	    # retrieve the video from the id
	    vid = Video.find(video_id)

	    # update the avg_rating for the video
	    vid.update_rating
	  end
	end


end