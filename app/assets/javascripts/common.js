$(document).ready(function() {
	$('.lnkbtn').click (function() {
	  $("#spinner").show();
	});

	$('.selectFieldAjax').change (function() {
	  $("#spinner").show();
	});

	$('#check_all').click (function() {
	  $(this).closest('table').find('input[type=checkbox]').prop('checked', this.checked);
	});

	$('#destroy_all').click (function() {
		var checked = $(".table input:checked").length > 0;
	  if (checked) {
	  	var msg = "Are you sure want to remove selected record(s)?";
	    if(confirm(msg)){
	      $("#index_form").submit();
	    } else {
	    	return false;
	    }
	  }else {
	  	alert('Please select atleast one record');
	  	return false;
	  }
	});

  $('#search_button').click(function(){
    $('.form-horizontal').trigger("reset");
    $('#search_form').show();
  });

});
$(function() {
  $('.pagination a').attr('data-remote', 'true')
});

