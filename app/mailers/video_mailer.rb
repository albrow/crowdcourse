class VideoMailer < ActionMailer::Base
  default from: "CrowdCourse<no-reply@crowdcourse.com>"

  def video_ready(video_id)
		@video = Video.find_by_id(video_id)
		@user = @video.creator
		mail(:to => @user.email, :subject => "Your Video is Ready")
  end

end
