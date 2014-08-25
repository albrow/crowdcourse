$(document).ready(function() {
	$(".category_id_select").change(function(){
	   var val = this.options[this.selectedIndex].value;
	   if (val == -1) {
	   	$(".category_text_field").show();
	   } else {
	   	$(".category_text_field").hide();
	   }
	});
});