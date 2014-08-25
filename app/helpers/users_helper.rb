module UsersHelper
	def gravatar_for(user, size=:small)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"

    # size parameters
    if size == :xxsmall
    	gravatar_url += "?s=18"
    elsif size == :xsmall
			gravatar_url += "?s=40"
    elsif size == :small
			gravatar_url += "?s=80"
    elsif size == :medium
			gravatar_url += "?s=185"
    elsif size == :large
			gravatar_url += "?s=400"
		end

		gravatar_url += "&d=identicon" # get a default geometric pattern if there is no icon.

    image_tag(gravatar_url, alt: user.username, class: "gravatar gravatar-#{size}")
  end
end
