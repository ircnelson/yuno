$(document).ready(function() {
	$('#loginForm').hide();
	$('p.toggle').click(function() {
	  $(this).prev().slideToggle();
	});
	$('a.toggleLogin').click(function() {
		$('#loginForm').slideToggle(300);
		return false;
	});
});
function load() { $('#spinner').show().css("display", "inline"); }

jQuery.ajaxSetup({ 
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")} 
})
