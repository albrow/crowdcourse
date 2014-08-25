function user_profile_initializer() {
	$(".user-description-link").click(function(e) {
		e.preventDefault();
		render_description_field();
	});
}

function render_description_field() {

	// when the change button is clicked, we render a field for the user to change their description

	var old_content = $.trim($(".description-content").html());
	var description_html = "<form action='#' method='put'>";
	description_html +=	"<textarea class='noresize' id='user_description' name='user[description]' rows='5'>";
	description_html += old_content + "</textarea>";
	description_html += "<input type='submit' value='Save' class='btn description-save-button'/>";
	description_html += "</form>";
	$(".description-content").html(description_html);
	$(".user-description-link").hide();

	setTimeout(function() {
		set_description_listeners();
	}, 200);

}

function set_description_listeners() {
	$(".description-save-button").click( function(e) {
		e.preventDefault();
		var content = $("#user_description").val();
		$.post("/users/update_description", { description: content } );
		reset_description(content);
	});
}

function reset_description(content) {
	
	// reset the description div to it's original state. Including updated content.
	$(".description-content").html(content);

	if (content.trim().length == 0) {
		$(".user-description-link").html("<a href=​'#' class=​'user-description-link'>add description</a>​");
		$(".user-description-link").show();
	} else {
		$(".user-description-link").html("<a href=​'#' class=​'user-description-link'>​change​</a>​");
		$(".user-description-link").show();
	}
}



