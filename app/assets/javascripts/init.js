$(document).ready(function(){

		var url = window.location.pathname;

		scroll_initializer();

		if (url.indexOf("quizzes") !== -1) {
			// we're in the quizzes controller, call the appropriate initializer
			quiz_initializer();

		} else if (url.indexOf("profile") !== -1) {
			// profile page
			user_profile_initializer();

		} else if ((url == "/") || (url.indexOf("landing") !== -1)) {
			// root or landing page
			mailing_list_init();

		} else if (url.indexOf("news") !== -1 ) {
			// news page
			mailing_list_init();
		
		} else if (url.indexOf("videos") !== -1 || (url.indexOf("components")) !== -1) {
			video_init();
		} 

});