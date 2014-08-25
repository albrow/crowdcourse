# When I originally designed the components model, there was no such thing as sections.
# I'm changing the structure from 
#    Course <-(has_many/belongs_to)-> Components 
# to 
# 	 Course <-(has_many/belongs_to)-> Sections <-(has_many/belongs_to)-> Components.

# Unrelatedly, I also decided to add a detailed_description attribute.

class ReviseComponentsToFitWithNewSectionsModel < ActiveRecord::Migration
  def up
  	# remove old columns and indeces
  	remove_index :components, :course_id
  	remove_column :components, :course_id

  	# add the new columns and indeces
		add_column :components, :section_id, :integer
		add_index :components, :section_id

		# add detailed_description
		add_column :components, :detailed_description, :text
  end

  def down
  	remove_column :components, :detailed_description

  	remove_index :components, :section_id
  	remove_column :components, :section_id

  	add_column :components, :course_id, :integer
  	add_index :components, :course_id
  end
end
