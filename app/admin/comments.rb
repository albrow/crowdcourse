ActiveAdmin.register Comment, :as => "MyComment" do
  # AA created a collision-prone resource system by using what is probably a fairly common name for models - "comment"
  # Hence, I had to do the annoying :as option to resolve the conflict.
  # This register still represents the model called Comment in my database

	index do

		h2 "Total Comments: #{Comment.all.size}"

		column :id
		column "Commenter" do |c|
			if !c.user.nil?
				link_to c.user.username, admin_user_path(c.user)
			end
		end
		column "Commented On" do |c|
			if !c.video.nil?
				link_to(c.video.component.name+": Video #"+c.video.id.to_s, admin_video_path(c.video)) + " by " + link_to(c.video.creator.username, admin_user_path(c.video.creator))
			elsif !c.quiz.nil?
				link_to c.quiz.component.name+" Quiz", admin_quiz_path(c.quiz)
			end
		end
		column "Time", :created_at
		column "Content" do |comment|
			truncate comment.content, :length => 40
		end
		column "Flags", :flags_count
		default_actions
	end

	form do |f|
		f.inputs "Details" do
			f.input :user, :label => "Commenter", :member_label => lambda{|u| u.username}
			f.input :video, :member_label => lambda{|v| v.component.name + ": Video #" + v.id.to_s + " by " + v.creator.username}
			f.input :quiz, :member_label => lambda{|q| q.component.name}
			f.input :content
		end
		
		f.buttons
	end

	show do |comment|
		attributes_table do
			row :id
			row :user do |u|
				if !comment.user.nil?
					link_to comment.user.username, admin_user_path(comment.user)
				end
			end
			row "Commented On" do |comment|
				if !comment.video.nil?
					link_to(comment.video.component.name+": Video #"+comment.video.id.to_s, admin_video_path(comment.video)) + " by " + link_to(comment.video.creator.username, admin_user_path(comment.video.creator))
				elsif !comment.quiz.nil?
					link_to comment.quiz.component.name+" Quiz", admin_quiz_path(comment.quiz)
				end
			end
			row :content
			row :created_at
			row :updated_at
		end
	end
	
end
