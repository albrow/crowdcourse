ActiveAdmin.register Flag do

  index do

		h2 "Total Flags: #{Flag.all.size}"

		column :id
		column :cause
		column "Flagger" do |flag|
			if !flag.user.nil?
				link_to flag.user.username, admin_user_path(flag.user)
			end
		end
		column "Flagged" do |flag|
			if !flag.video.nil?
				link_to(flag.video.component.name+": Video #"+flag.video.id.to_s, admin_video_path(flag.video)) + " by " + link_to(flag.video.creator.username, admin_user_path(flag.video.creator))
			elsif !flag.quiz.nil?
				link_to flag.quiz.component.name+" Quiz", admin_quiz_path(flag.quiz)
			elsif !flag.comment.nil?
				link_to("Comment #"+flag.comment.id.to_s, admin_my_comment_path(flag.comment)) + " by " + link_to(flag.comment.user.username, admin_user_path(flag.comment.user))
			end
		end
		column "Time", :created_at
		default_actions
	end

	form do |f|
		f.inputs "Details" do
			f.input :cause
			f.input :user, :label => "Flagger", :member_label => lambda{|u| u.username}
			f.input :video, :member_label => lambda{|v| v.component.name + ": Video #" + v.id.to_s + " by " + v.creator.username}
			f.input :quiz, :member_label => lambda{|q| q.component.name}
			f.input :comment, :member_label => lambda{|c| "#" + c.id.to_s + " by " + c.user.username}
		end
		
		f.buttons
	end

	show do |flag|
		attributes_table do
			row :id
			row :user do |u|
				if !flag.user.nil?
					link_to flag.user.username, admin_user_path(flag.user)
				end
			end
			row "Flagged" do |flag|
				if !flag.video.nil?
					link_to(flag.video.component.name+": Video #"+flag.video.id.to_s, admin_video_path(flag.video)) + " by " + link_to(flag.video.creator.username, admin_user_path(flag.video.creator))
				elsif !flag.quiz.nil?
					link_to flag.quiz.component.name+" Quiz", admin_quiz_path(flag.quiz)
				elsif !flag.comment.nil?
					link_to("Comment #"+flag.comment.id.to_s, admin_my_comment_path(flag.comment)) + " by " + link_to(flag.comment.user.username, admin_user_path(flag.comment.user))
				end
			end
			row :cause
			row :created_at
			row :updated_at
		end
	end

end
