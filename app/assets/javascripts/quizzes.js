


// ------- Globals ---------

var questions = [];
var current_question;

// for keeping track of the score...
var current_score = 0;
var num_questions = 0;
var num_attempts = 0;
var points_per_question = 0;
var choices_per_current_question = 0;

// keeps track of submissions to prevent multiple submissions on field questions
// also advances to the next question if appropriate
var already_submitted = false;

// ------- End globals ---------




// -------------------------  Initializer ----------------------------------------------

function quiz_initializer() {
	get_questions();

	// prevent multiple submissions on field questions
	$(window).keydown(function(event){
		if( (event.keyCode == 13) && (already_submitted == true) ) {
			event.preventDefault();
			next_question();
			return true;
		}
	});
}



// ---------------------------  Get Questions  -------------------------------

function get_questions() {
	$.ajax({
	  url: window.location.pathname + "/get_questions",
	  context: document.body
	}).done(function(data) { 
	  questions = eval(data);

	  // update some globals for score calculation
	  num_questions = questions.length;
	  points_per_question = 100 / num_questions;
	  num_attempts = 0;

	  current_question = questions.pop();
	  if (current_question.type == "choice") {
	  	choices_per_current_question = current_question.choices.length;
	  	$(".question-container").html(render_choice_question(current_question));
		} else {
			choices_per_current_question = 4;
			$(".question-container").html(render_field_question(current_question));

			// Set the focus automatically. unfortunately this doesn't work without the timeout.
			setTimeout( function() {
				var form = $(".field-question-form"); 
				$("input[name='choice']", form).focus(); 
			}, 500 );
		}

		//MathJax.Hub.Queue(["Typeset",MathJax.Hub]);
		
		// set up the interactive parts of the interface...
		set_listeners();
		add_hover_pointer();
	});
}







// --------------------------------  Proceed to Next Question  --------------------------------

function next_question() {
	current_question = questions.pop();
	if (current_question) {
		$(".question-container").fadeOut(200, function() {
			if (current_question.type == "choice") {
				
				// Code for CHOICE QUESTIONS

				$(this).html(render_choice_question(current_question));
				
				// the timeout helps fix occaisonal bugs in rendering
				setTimeout( function() {
					MathJax.Hub.Queue(["Typeset",MathJax.Hub]); //re-render AsciiMath
				}, 10 );
				
				choices_per_current_question = current_question.choices.length;
				num_attempts = 0;

				// unfreeze the interface...
				set_listeners();
				add_hover_pointer();

				// reset submission tracker
				already_submitted = false;

			}else {

				// code for FIELD QUESTIONS

				$(this).html(render_field_question(current_question));
				choices_per_current_question = 4;
				num_attempts = 0;

				// the timeout helps fix occaisonal bugs in rendering
				setTimeout( function() {
					MathJax.Hub.Queue(["Typeset",MathJax.Hub]); //re-render AsciiMath
				}, 10 );
				
				// Set the focus automatically. unfortunately this doesn't work without the timeout.
				setTimeout( function() {
					var form = $(".field-question-form"); 
					$("input[name='choice']", form).focus();
				}, 500 );

				// reset submission tracker
				already_submitted = false;
				
			}

		}).fadeIn(300);
	} else {

		// if we reach here, the quiz is done.
		$.ajax({
		  url: window.location.pathname + "/complete/" + Math.ceil(current_score),
		  context: document.body
		}).done(function(data) { 
		  $(".question-container").fadeOut(200, function() {
		  	$(this).html(data);
		  }).fadeIn(300);
		});

	}
}








// --------------------  Answer Checkers  -----------------------------

function check_choice_answer(question, choice) {
	var is_answer = (question.answer_id == choice.attr("id"));
  if (is_answer) {

		// update this variable (has the effect of "freezing" the interface)
		$(".choice-container").unbind();
		remove_hover_pointer(); // a part of the freezing effect, so choices don't look clickable

		// update the current score
		points = points_per_question;
		if (num_attempts < choices_per_current_question - 1) {
			points = points * Math.pow(2, (0-num_attempts)); // each failed attempt divides the number of points by two
			current_score += points;
		} else {
			current_score += 0;
		}

		$(".choice-result").html("That's correct! <a class='hover-pointer next-question'>Next Question</a>");

		// add a click listener for the "next question" button
		$(".next-question").click(function(e) {
			e.preventDefault();
			next_question();
		});

		already_submitted = true; // prevent multiple submissions


  } else {
		$(".choice-result").html("Sorry, that's incorrect. Guess again.");
		num_attempts += 1;
		choice.stop(true, true);
		choice.delay(100).addClass("disabled", 300).unbind();
		choice.removeClass("active", 100);
		choice.removeClass("hover-pointer");
  }
}





function check_field_answer () {
	var form = $(".field-question-form");
	choice = $("input[name='choice']", form);

	if (choice.val() == "" || choice.val() == null) {
		// we don't want to count it as an incorrect answer if it's blank
		return;
	}

	var is_answer = (current_question.answer == choice.val());

  if (is_answer) {

		// update the current score
		points = points_per_question;
		if (num_attempts < choices_per_current_question - 1) {
			points = points * Math.pow(2, (0-num_attempts)); // each failed attempt divides the number of points by two
			current_score += points;
		} else {
			current_score += 0;
		}

		choice.attr("disabled", "disabled");
		choice.addClass("color-white");
		choice.addClass("active", 250);

		

		$(".choice-result").html("That's correct! <a class='hover-pointer next-question'>Next Question</a>");

		// add a click listener for the "next question" button
		$(".next-question").click(function(e) {
			e.preventDefault();
			next_question();
		});

		already_submitted = true; // prevent multiple submissions

		$(".answer-submit-button").click(function (e) {
			if (already_submitted) {
		  	e.preventDefault();
		  	next_question();
		  }
		});

  } else {
		
		num_attempts += 1;
		if (num_attempts >= choices_per_current_question - 1) {

			$(".choice-result").html("That's incorrect. You're out of guesses. <a class='hover-pointer next-question'>Next Question</a>");

			// disable the input field and remove focus
			choice.attr("disabled", "disabled");
			choice.blur();

			already_submitted = true; // this makes pressing enter advance to the next question.

			// add a click listener for the "next question" button
			$(".next-question").click(function(e) {
				e.preventDefault();
				next_question();
			});

		} else {

			$(".choice-result").html("Sorry, that's incorrect. Guess again.");

			
			// put the focus back on the text field automatically
			setTimeout( function() {
				var form = $(".field-question-form"); 
				$("input[name='choice']", form).focus(); 
			}, 500 );

		}

		choice.val(""); // clear the input field
  }
}









// ---------------  Set Listeners on Choice Containers ---------------------

function set_listeners(choices) {

	// set up a click listener for each choice...

  $(".choice-container").click(function() {
  	$(".choice-container").removeClass("active");
  	$(this).addClass("color-white");
		$(this).addClass("active", 250);
		$(this).removeClass("hover");
		check_choice_answer(current_question, $(this));
	});

	// and a hover listener

	$(".choice-container").hover(function() {
		// a function for mouseEnter...
		if (!($(this).hasClass("active"))) {
			$(this).addClass("hover", 200);
		}
	}, function() {
		// a function for mouseLeave...
		$(this).stop(true, true).removeClass("hover", 200);
	});


}






// -----------------  Question Renderers  ----------------------

function render_choice_question(question) {
	// this method renders all the necessary html to display the question
	var html_string = "<div class='question-description' id='"+ question.id +"'>";
	html_string += question.description;
	html_string += "</div>";
	alpha = ["A", "B", "C", "D", "E", "F", "G", "H"];
	for (var i = 0; i < question.choices.length; i++) {
		html_string += "<div class='choice-letter'>"+ alpha[i] +".</div>";
		html_string += render_choice(question.choices[i]);
	}
	html_string += "<div class='choice-result'>&nbsp;</div>";
	return html_string;
	
}

function render_choice(choice) {
	var choice_html = ""; 
	
	choice_html += "<div class='choice-container blue' id ='"+ choice.id +"'value='" + choice.content + "'>";

	// // if you want to make the color of each choice:hover different...
	// switch (choice.id % 4) {
	// 	case 0: 
	// 		choice_html += "<div class='choice-container purple' value='" + choice.content + "'>";
	// 		break;
	// 	case 1:
	// 		choice_html += "<div class='choice-container grey' value='" + choice.content + "'>";
	// 		break;
	// 	case 2:
	// 		choice_html += "<div class='choice-container blue' value='" + choice.content + "'>";
	// 		break;
	// 	case 3:
	// 		choice_html += "<div class='choice-container green' value='" + choice.content + "'>";
	// 		break;
	// 	default:
	// 		// should never reach this...
	// 		choice_html += "<div class='choice-container grey' value='" + choice.content + "'>";
	// 		break;
	// }
	choice_html += choice.content + "</div>";
	return choice_html;
}

function render_field_question(question) {
	// this method renders all the necessary html to display the question
	var html_string = "<div class='question-description' id='"+ question.id +"'>";
	html_string += question.description;
	html_string += "</div>";

	html_string += "<form class='field-question-form' onsubmit='check_field_answer(); return false;'>";
		html_string += "<div class='choice-letter'>A:</div>"
		html_string += "<input type='text' class='quiz-answer' name='choice' placeholder='your answer'/>";
		html_string += "<input type='submit' value='Submit' class='btn btn-large answer-submit-button' />"
	html_string += "</form>";

	html_string += "<div class='choice-result'>&nbsp;</div>";

	return html_string;

}







// -------------  Hover Pointer Controls  -----------------

function add_hover_pointer() {
	// this adds a class which has the effect of changing the cursor when you hover over the element
	$(".choice-container").addClass("hover-pointer");
	$(".choice-container.disabled").removeClass("hover-pointer");
}

function remove_hover_pointer() {
	$(".choice-container").removeClass("hover-pointer");
}







