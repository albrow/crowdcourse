# == Schema Information
#
# Table name: activities
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  kind       :string(255)
#  data       :text
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Activity < ActiveRecord::Base

	# The data column holds a serialized json string with information about the activity
	# it is automatically encoded before save
	# to get the decoded array/hash, use decoded_data method
  
  attr_accessible :user_id, :kind, :data, :created_at
	belongs_to :user
	before_save :serialize_data


	def serialize_data
		# if the data was inputted as a hash (for convenience),
		# we serialize it and store it in the db as a string automatically
		if data.class == Hash
			j = ActiveSupport::JSON
			self.data = j.encode(self.data)
		end
	end

	def decoded_data
		# returns the decoded version of the data (which is stored as JSON)
		j = ActiveSupport::JSON
		return j.decode(self.data)
	end

end
