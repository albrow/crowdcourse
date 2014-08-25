module ApplicationHelper

	## --- CONSTANTS ---

	$player_color = "009193"


  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "CrowdCourse"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

	# renders a pill item (really an li) that is either active or not based on the page that's being viewed
	def pill(name, path, active)
		if name == "Sign In" && active != "Sign In"
			# for this special case, we render a modal...
			"<li><a href='#signin-modal' data-toggle='modal'>Sign In</a></li>"
		elsif name == active
			link = link_to name, path
			"<li class='active'>
				#{link}		   	
			</li>"
		else
			link = link_to name, path
			"<li>
				#{link}		   	
			</li>"
		end
	end


	# renders a video in an iframe. Three different size options: small, medium, large
	def render_video(url, size=:medium)

		if (size == :small)
			width = 450
			height = 300
		elsif (size == :medium)
			width = 720
			height = 480
		elsif (size == :large)
			width = 800
			height = 450
		end
		iframe_string = "<iframe src='#{url}"
		iframe_string += "?color=#{$player_color}&portrait=0&title=0&byline=0%api=1&player_id=' " # some paramaters for the player
		iframe_string += "width='#{width}' height='#{height}' "
		iframe_string += "frameborder='0' webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>"

		return iframe_string.html_safe

	end


end