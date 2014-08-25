class AddActivityTrackingToEnrollments < ActiveRecord::Migration

	# These additions help track the users activity pertaining to courses
	# The last_active entry will help us determine which course to attribute activity to
	# for components that belong to multiple courses, we need to know which one is relevant to the user
	# could also help with breadcrumbs

  def up
  	change_table :enrollments do |t|
			t.boolean :show, :default => :true       # the user can hide the enrollment from their profile if they don't wish to track their progress
			t.time :last_active    									 # the last time the user viewed, watched a video, took a quiz, etc. related to the course
  	end
  end

  def down
		remove_column :enrollments, :last_active
		remove_column :enrollments, :show
  end
end