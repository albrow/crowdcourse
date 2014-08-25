ActiveAdmin.register User do
  
  index do

    h2 "Total Users: #{User.all.size}"
    
		column :id
    column :username
		column :email
		column :full_name
    column "Courses" do |user|
      (user.courses.map{|c| link_to c.name, admin_course_path(c) }).join(', ').html_safe
    end
    column :points
		column :created_at

		default_actions
  end

  form do |f|
  	f.inputs "Identification" do
      f.input :username
  		f.input :email
  		f.input :full_name
      f.input :description
      f.input :is_bot
  	end

    f.inputs "Activity" do
      f.input :points
      f.input :avg_quiz_score
    end

  	f.has_many :enrollments do |e|
  		e.input :course
  		e.input :progress_as_percent
  		e.input :num_videos_watched
  		e.input :num_quizzes_passed
  	end



    f.has_many :badge_earnings do |b|
      b.input :badge
      b.input :created_at
    end

  	f.buttons
  end

  show do |user|

    panel "Identification" do
      attributes_table_for user do
        row :id
        row :username
        row :email
        row :full_name
        row :description
        row :is_bot

        row :created_at
        row :updated_at
      end
    end

    panel "Enrollments" do
      attributes_table_for user do
        row "Courses" do |user|
          (user.courses.map{|c| link_to c.name, admin_course_path(c) }).join(', ').html_safe
        end
      end
    end

    panel "Acivity" do
      attributes_table_for user do
        row :points
        row "# Badges Earned" do
          user.badges.size
        end
        row "Badges Earned" do
          (user.badges.map{|b| link_to b.name, admin_badge_path(b) }).join(', ').html_safe
        end
        row :avg_quiz_score
        row "Videos Made" do
          user.videos_made.size
        end
        row "# Videos Viewed" do
          user.videos_viewed.size
        end
        row "# Quizzes Taken" do
          user.quizzes_taken.size
        end
        row "# Comments Made" do
          user.comments.size
        end
        row "# Flagges Thrown" do
          user.flags.size
        end
      end
    end

     
    panel "Miscellaneous" do
      attributes_table_for user do
        row :reset_password_token
        row :reset_password_sent_at
        row :remember_created_at
        row :sign_in_count
        row :current_sign_in_at
        row :last_sign_in_at
        row :current_sign_in_ip
        row :last_sign_in_ip
        row :confirmation_token
        row :confirmed_at
        row :unconfirmed_email
      end
    end

  end

end
