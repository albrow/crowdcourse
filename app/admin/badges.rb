ActiveAdmin.register Badge do

  index do

		earned_badges_count = 0
		User.all.each {|u| earned_badges_count += u.badges.size }
		h2 "Total Badges Earned: #{earned_badges_count}"

		column :id
		column :name
		column "# Earnings" do |badge|
			badge.users.size
		end
		
		default_actions
	end

	form do |f|
		f.inputs "Details" do
			f.input :name
			f.input :description
			f.input :image_large
			f.input :image_small
		end
		
		f.buttons
	end

	show do |course|
		attributes_table do
			row :id
			row :name
			row :description
			row :image_large
			row :image_small
			row "# Earnings" do |badge|
				badge.users.size
			end
			row :created_at
			row :updated_at
		end
	end


end
