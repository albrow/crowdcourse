ActiveAdmin.register Component do

	menu :parent => "Curricula", :priority => 4

	index do

		h2 "Total Components (aka Lessons): #{Component.all.size}"

		column :id
		column :priority
		column :name
		column :alias
		column "Section" do |comp|
		  link_to comp.section.name, admin_section_path(comp.section) if comp.section
		end
		column "Course" do |comp|
			link_to comp.course.name, admin_course_path(comp.course) if comp.course
		end 
		column :quiz
		column "# Videos" do |comp|
			comp.videos.size
		end
		default_actions
	end

	form do |f|
		f.inputs "Details" do
			f.input :priority
			f.input :name
			f.input :alias
			f.input :description
			f.input :detailed_description
			f.input :section
		end

		f.buttons
	end

	show do |comp|
		attributes_table do
			row :id
			row :priority
			row :name
			row :alias
			row :description
			row :detailed_description
			row "Section" do |comp|
			  link_to comp.section.name, admin_section_path(comp.section) if comp.section
			end
			row :course
			row :quiz
			row "# Videos" do |comp|
				comp.videos.size
			end
			row "Videos" do |comp|
				(comp.videos.map{|v| link_to("Video ##{v.id}", admin_video_path(v)) + " by " + link_to(v.creator.username, admin_user_path(v.creator)) }).join(" ,  &nbsp;&nbsp;").html_safe
			end
			row :created_at
			row :updated_at
		end
	end
  
end
