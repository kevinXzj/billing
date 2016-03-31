# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(".bill_import_logs.index").ready -> 
	$('#lefile').change ->
		$('#photoCover').val($(this).val());	
	$('#selectBtn').click ->
		$('#lefile').click()
	$('#uploadBtn').click ->
		if($('#company_id').val()=="")
			return alert("请选择套餐")
		else if($('#year').val()=="")
			return alert("请选择账单年份")
		else if($('#month').val()=="")
			return alert("请选择账单月份")
		else if($('#lefile').val()=="")
			return alert("请选择上传文件")
		else
			$('#submit_btn').click()
