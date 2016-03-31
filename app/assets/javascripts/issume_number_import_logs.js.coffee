# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(".issue_number_import_logs.index").ready -> 
	$('#lefile').change ->
		$('#photoCover').val($(this).val());	
	$('#selectBtn').click ->
		$('#lefile').click()
	$('#uploadBtn').click ->
		if($('#lefile').val()=="")
			return alert("请选择上传文件")
		else
			$('#submit_btn').click()