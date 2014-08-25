ActiveAdmin::Dashboards.build do

  # Define your dashboard sections here. Each block will be
  # rendered on the dashboard in the context of the view. So just
  # return the content which you would like to display.

  section "Statistics", :priority => 2 do
    div :class => "stats-container" do
      render "stats"
    end
  end

  section "Links", :priority => 3 do
    ul do
      li link_to "CrowdCourse", root_path
      li link_to "Mail", "http://mail.crowdcourse.com"
      li link_to "Vimeo", "https://vimeo.com/crowdcourse/videos"
      li link_to "Heroku", "https://api.heroku.com/myapps"
    end
  end

  section "Flagged", :priority => 1 do
    div do
      b "Videos"
      # get all videos with at least 1 flag, sort then by # flags, and list the top 5...
      Video.where("flags_count > 0").sort {|x, y| y.flags.size <=> x.flags.size}.slice(0..4).collect do |v|
        li link_to(v.component.name+": Video #"+v.id.to_s, admin_video_path(v)) + " by " + link_to(v.creator.username, admin_user_path(v.creator)) + " .... " + v.flags.size.to_s + " flags"
      end
    end
    hr
    div do
      b "Comments"
      Comment.where("flags_count > 0").sort {|x, y| y.flags.size <=> x.flags.size}.slice(0..4).collect do |c|
        li link_to("Comment #"+c.id.to_s, admin_my_comment_path(c)) + " by " + link_to(c.user.username, admin_user_path(c.user)) + " .... " + c.flags.size.to_s + " flags"
      end
    end
    hr
    div do
      b "Quizzes"
      Quiz.all.sort {|x, y| y.flags.size <=> x.flags.size}.slice(0..4).collect do |q|
        li link_to(q.component.name, admin_quiz_path(q)) +  " .... " + q.flags.size.to_s + " flags"
      end
    end
  end

  section "Power Users", :priority => 4 do
    ul do
      User.all.sort {|x, y| y.points <=> x.points }.slice(0..5).collect do |u|
        li link_to(u.username, admin_user_path(u)) + " .... " + u.points.to_s + " points"
      end
    end
  end

  
  # == Simple Dashboard Section
  # Here is an example of a simple dashboard section
  #
  #   section "Recent Posts" do
  #     ul do
  #       Post.recent(5).collect do |post|
  #         li link_to(post.title, admin_post_path(post))
  #       end
  #     end
  #   end
  
  # == Render Partial Section
  # The block is rendered within the context of the view, so you can
  # easily render a partial rather than build content in ruby.
  #
  #   section "Recent Posts" do
  #     div do
  #       render 'recent_posts' # => this will render /app/views/admin/dashboard/_recent_posts.html.erb
  #     end
  #   end
  
  # == Section Ordering
  # The dashboard sections are ordered by a given priority from top left to
  # bottom right. The default priority is 10. By giving a section numerically lower
  # priority it will be sorted higher. For example:
  #
  #   section "Recent Posts", :priority => 10
  #   section "Recent User", :priority => 1
  #
  # Will render the "Recent Users" then the "Recent Posts" sections on the dashboard.
  
  # == Conditionally Display
  # Provide a method name or Proc object to conditionally render a section at run time.
  #
  # section "Membership Summary", :if => :memberships_enabled?
  # section "Membership Summary", :if => Proc.new { current_admin_user.account.memberships.any? }

end