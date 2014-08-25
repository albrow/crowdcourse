ActiveAdmin.register Course do

	menu :parent => "Curricula", :priority => 2

	index do
		h2 "Total Courses: #{Course.all.size}"
		column :id
		column :priority
		column :name
		column "Categories" do |course|
		  (course.categories.map{|c| link_to c.name, admin_category_path(c) }).join(', ').html_safe
		end
		column :has_sections
		column "# Lessons" do |course|
			course.components.size
		end
		column "Users Enrolled" do |course|
			course.users.size
		end
		default_actions
	end

	form do |f|
		f.inputs "Basics" do
			f.input :priority
			f.input :name
			f.input :description
		end

		f.inputs "Images" do
			f.input :image_small
			f.input :image_large
		end

		f.inputs "Categories" do
			f.input :categories, :as => :check_boxes
		end

		f.inputs "Sections" do
			f.input :has_sections
		end
		
		f.buttons
	end

	show do |course|
		attributes_table do
			row :id
			row :priority
			row :name
			row :description
			row :image_large
			row :image_small
			row "Categories" do |course|
			  (course.categories.map{|c| link_to c.name, admin_category_path(c) }).join(', ').html_safe
			end
			row :has_sections
			row "Sections" do |course|
				(course.sections.map{|s| link_to s.name, admin_section_path(s) }).join(', ').html_safe
			end
			row "Components (aka Lessons)" do |course|
				(course.components.map{|c| link_to c.name, admin_component_path(c) }).join(', ').html_safe
			end
			row "Users Enrolled" do |course|
				(course.users.map {|u| link_to(u.username, admin_user_path(u))}).join(", ").html_safe
			end
			row :created_at
			row :updated_at
		end
	end
  
end
