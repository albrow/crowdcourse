ActiveAdmin.register Video do
  
	index do
		
		h2 "Total Videos: #{Video.all.size}"

		column :id
		column :embed_url
		column :visible
		column :ready
		column :component do |v|
			if !v.component.nil?
				link_to v.component.name, admin_component_path(v.component)
			end
		end
		column "Creator" do |v|
			if !v.creator.nil?
				link_to v.creator.username, admin_user_path(v.creator)
			end
		end
		column "Flags", :flags_count
		column :avg_rating
		column "Time", :created_at

		default_actions
	end

	form do |f|
		f.inputs "Details" do
			f.input :creator, :member_label => lambda{|u| u.username}
			f.input :component
			f.input :embed_url
			f.input :visible
			f.input :ready
			f.input :kind
			f.input :duration
			f.input :avg_rating
			f.input :avg_quiz_score

			f.input :created_at
			f.input :updated_at
		end

		f.buttons
	end

	show do |video|
		attributes_table do
			row :id
			row :component do |v|
				if !v.component.nil?
					link_to v.component.name, admin_component_path(v.component)
				end
			end
			row "Creator" do |v|
				if !v.creator.nil?
					link_to v.creator.username, admin_user_path(v.creator)
				end 
			end
			row :embed_url
			row :visible
			row :ready
			row :kind
			row :duration
			row :avg_rating
			row :avg_quiz_score
			row :created_at
			row :updated_at
		end
	end

end
