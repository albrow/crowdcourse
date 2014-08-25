class AddHasSectionsToCourses < ActiveRecord::Migration

	# The has_sections attribute specifies whether or not a course
	# has been divided up into sections.

	# Note: every course HAS AT LEAST ONE section in the database
	# However, for the courses with only one section, we don't need to show that section.
	# and to the user, all the lessons in that course should appear as direct children
	# of the course. I.e. a course with one section doesn't make any sense 
	# (but is necessary in the db and models)

	# The has_sections attribute tells us whether or not the sections of
	# a course should be displayed to the end user.


	# An example of possible view logic...

	# if course.has_sections
	# 		course.sections.each {|section| render section}
	# else
	#			course.lessons.each {|lesson| render lesson}
	# end



  def change
  	add_column :courses, :has_sections, :boolean, :default => true
  end

end
