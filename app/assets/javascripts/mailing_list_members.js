function mailing_list_init() {
	$(".mailing-list-button").click( function(e) {
		e.preventDefault();
		var content = $("#mailing_list_member_email").val();
		var success = false;
		var result = $.post("/mailing_list_members/create", { email: content }, function() {
			success = eval(result.responseText);
			if (success) {
				render_mailing_list_success();
			} else {
				render_mailing_list_failure();
			}
		} );
	});
}

function render_mailing_list_success() {
	$(".mailing-list-form").fadeOut(200, function() {
		$(this).html("Thanks for your interest.<br/><br/>We'll keep you updated about our progress!");
	}).fadeIn(300);
}

function render_mailing_list_failure() {
	$(".mailing-list-form").fadeOut(200, function() {
		$(this).html("Looks like you've already signed up.<br/><br/>We'll keep you updated about our progress!");
	}).fadeIn(300);
}
