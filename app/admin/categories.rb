ActiveAdmin.register Category do

	menu :parent => "Curricula", :priority => 1

	index do

		h2 "Total Categories: #{Category.all.size}"

		column :id
		column :name
		#list and create links to all the courses
		column "Courses" do |category|
		  (category.courses.map{|c| link_to c.name, admin_course_path(c) }).join(', ').html_safe
		end
		default_actions
	end

	form do |f|
		f.inputs "Basics" do
			f.input :name
			f.input :description
		end

		f.inputs "Images" do
			f.input :image_small
			f.input :image_large
		end

		f.inputs "Courses" do
			f.input :courses, :as => :check_boxes
		end
		
		f.buttons
	end

	show do |cat|
		attributes_table do
			row :id
			row :name
			row :description
			row :image_large
			row :image_small
			row "Courses" do |cat|
			  (cat.courses.map{|c| link_to c.name, admin_course_path(c) }).join(', ').html_safe
			end
			
			row :created_at
			row :updated_at
		end
	end

end
