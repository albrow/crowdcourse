scroll_initializer = function() {

	// adds a smooth scrolling animation to internal links...
	$(".smooth-scroll").click(function(event){		
		event.preventDefault();
		end_pos = $(this.hash).offset().top;
		scrollWindow(end_pos);
	});

	// adds a "back to top" link on the side of the screen when appropriate...

	var top = $(document.body).children(0).position().top;
	var width = $(window).width();
	var position = $(window).scrollTop();

	var width_timer;
	var position_timer;

	var top_link_visible = false;
	var position_valid = false;
	

	$(window).scroll(function() {

		// here we use a timer for better performance

		window.clearTimeout(position_timer);

    position_timer = window.setTimeout(function () {
        update_position();
        update_top_link();
    }, 100);

  });

  $(window).resize( function() {
	
    update_width();
    update_top_link();
  
  });

	update_position = function() {
		position = $(window).scrollTop();
		if(position <= (top + 300)) {
			// the scroll position is such that we should show the top-link
    	position_valid = false;
    } else {
    	// the scroll position is close to the top, so we don't the top-link
    	position_valid = true;
    }
	}

	update_width = function() {
		width = $(window).width();
	}

	update_top_link = function() {
		// a function that shows or hides top-link based on certain conditions
		// the conditions are window width and scroll position
		
		if (!position_valid) {
			// the scroll position is close to the top, so we should not show the top-link
			if (top_link_visible) {
				hide_top_link();
				top_link_visible = false;
			}

		} else if ( width <= 1063 ) {
			// there's no room, so we hide top-link completely
			if (top_link_visible) {
				hide_top_link();
				top_link_visible = false;
			}

		} else if (width <= 1150) {
			// we need to move the top-link slightly so it doesn't block the text
			$(".top-link").css( "right", "-5px" );
			if (!top_link_visible && position_valid) {
				show_top_link();
				top_link_visible = true;
			}
		} else {
			$(".top-link").css( "right", "3%" );
			if (!top_link_visible && position_valid) {
				show_top_link();
				top_link_visible = true;
			}
		}

	};

  show_top_link = function() {
		$(".top-link").css({
			opacity: 0.0,
			filter: "alpha(opacity=0)",
			visibility: "visible"
		}).animate({
			filter: "alpha(opacity=50)",
			opacity: 0.5
		}, 200);
		top_link_visible = true;
  };

  hide_top_link = function() {
		$(".top-link").animate({
			filter: "alpha(opacity=0)",
			opacity: 0.0
		}, 200, function() {
			$(this).css("visibility", "hidden");
		});
		top_link_visible = false;
  };

};

function scrollWindow(start_pos, end_pos) {
	distance = Math.abs(end_pos - start_pos);
	time = distance/4.5 + 200 ; // set a time based on distance (gives consistent speed)
	if (time > 450) {
		time = 450; // don't want it to be longer than this
	}
	$('html,body').animate({scrollTop: end_pos}, time, 'easeOutCirc');
}

function scrollWindow(end_pos) {
	start_pos = $(window).scrollTop();
	distance = Math.abs(end_pos - start_pos);
	time = distance/4.5 + 200 ; // set a time based on distance (gives consistent speed)
	if (time > 450) {
		time = 450; // don't want it to be longer than this
	}
	$('html,body').animate({scrollTop: end_pos}, time, 'easeOutCirc');
}

