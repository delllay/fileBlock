<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>파일 확장자</title>

<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" integrity="sha384-WskhaSGFgHYWDcbwN70/dfYBj47jz9qbsMId/iRN3ewGhXQFZCSftd1LZCfmhktB"
	crossorigin="anonymous">
<link rel="stylesheet" href="/fileBlock/resources/css.css" type="text/css">

</head>
<body>
	<div class='container m-2'>
		<div class='page-header  m-5'>
			<h2>◎ 파일 확장자 차단 확인</h2>
		</div>
		<form id="fileForm">
			<input type="file">
			<button id="uploadBtn" type="button" class='btn btn-default'>확인하기</button>
		</form>
		<hr class='wideHr'>
		<div class='page-header m-5'>
			<h1>◎ 파일 확장자 차단</h1>
			<hr style="width: 3px;">
			<small>파일 확장자에 따라 특정 형식의 파일을 첨부하거나 전송하지 못하도록 제한</small>
		</div>
		<hr>
		<div>
			<div class='row'>
				<div class='col-lg-4'>고정 확장자</div>
				<div>
					<ul id='fixedExtension' class='row list-unstyled'>
						<c:forEach items="${extensionMap.fixedExtensionList}" var="extension">
							<li class='mr-4'><input type="checkbox" id="${extension.name}" idx="${extension.id}" <c:if test="${extension.status}">checked</c:if>> <label for="${extension.name}">${extension.name}</label></li>
						</c:forEach>
					</ul>
				</div>
			</div>
			<hr>
			<div>
				<div class='row'>
					<div class='col-lg-4'>커스텀 확장자</div>
					<div class='col-lg-8  p-0'>
						<div class='row'>
							<input type="text" id='extension' placeholder="확장자 입력" class='form-control mr-4 col-lg-6'>
							<button id='extensionAddBtn' class='btn'>+ 추가</button>
						</div>
						<div id='customExtension' class='border p-4 mt-4'>
							<div class="mb-2">
								<span id='customCount'>${fn:length(extensionMap.customExtensionList)}</span> / 200
							</div>
							<div class='customExtensionDiv border p-2 m-2 row'>
								<c:forEach items="${extensionMap.customExtensionList}" var="extension">
									<div class='m-1 row'>
										<div class="m-2" idx="${extension.id}">${extension.name}</div>
										<button class='extensionDelBtn btn btn-danger btn-xs'>X</button>
									</div>
								</c:forEach>
							</div>
						</div>
					</div>

				</div>

			</div>
		</div>
	</div>
</body>

<script  src="http://code.jquery.com/jquery-latest.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js" integrity="sha384-smHYKdLADwkXOn1EmN1qk/HfnUcbVRZyYmZ4qpPea6sjB/pTJ0euyQp0Mk8ck+5T" crossorigin="anonymous"></script>

<script type="text/javascript">
	$("#uploadBtn").click(function(e) {
		e.preventDefault();
		var file = $(this).prev('input').val();
		if(file==""){
			alert('확인할 파일을 등록하세요.');
		}else{
			var fileValue = file.split("\\");
			var fileExtension = fileValue[fileValue.length-1].split(".")[1];
			
			$.ajax({
				url : "extensionCheck",
				type : "POST",
				data : {
					fileExtension : fileExtension
				},
				success : function(extension) {
					if(extension){
						alert('해당 파일은 업로드 불가능합니다.');
					}else{
						alert('해당 파일은 업로드 가능합니다.');
					}
				},
				error:function(e){
	               console.log(e);
	            }

			});
		}
	});


	$("#extensionAddBtn").click(function() {
		var extensionName = $(this).parent().children('input').val();
		var customCount = $("#customExtension").children('.customExtensionDiv').children('div').length;

		if(extensionName.length <= 20){
			if( customCount < 200){
				$.ajax({
					url : "insertExtension",
					type : "POST",
					data : {
						name : extensionName,
						type : 'custom'
					},
					success : function(id) {
						if(id<0){
							alert('이미 등록된 확장자 입니다.');
							false;
						}
						else if(id==0){
							alert('고정 확장자 입니다. 위의 체크박스에서 설정해주세요.');
							false;
						}
						else{
							$("#customExtension>.customExtensionDiv").append(
									"<div class='m-1 row'>"+
										"<div class='m-2' idx='"+ id +"'>"+ extensionName +"</div>"+
										"<button class='extensionDelBtn btn btn-danger btn-xs'>X</button>"+
									"</div>"	
							);
							$("#customCount").text( $("#customExtension").children('.customExtensionDiv').children('div').length);
						}
					},
					error:function(e){
		               console.log(e);
		            }
	
				});
				
				$(this).parent().children('input').val('');
			} else{
				alert('커스텀 확장자는 최대 200개까지 차단 가능합니다.')
			}
		}else{
			alert('확장자의 최대 입력 길이는 20자리 입니다.')
		}

	});
	
	$("#fixedExtension input[type='checkbox']").change(function() {
		var extensionName = $(this).attr('id');
		var extensionId = $(this).attr('idx');
		var extensionStatus = $(this).is(":checked");

		$.ajax({
			url : "updateExtension",
			type : "POST",
			data : {
				id : extensionId,
				name : extensionName,
				type : 'fixed',
				status : extensionStatus
			},
			success : function(data) {
			},
			error : function() {
			}
		});
	});
	
	$(document).on("click",".extensionDelBtn",function(){
		var extension = $(this).prev();
		var extensionName = extension.text();
		var extensionId = extension.attr('idx');
		
		$.ajax({
			url : "deleteExtension",
			type : "POST",
			data : {
				id : extensionId
			},
			success : function(data) {
				extension.parent().remove();
				$("#customCount").text($("#customExtension").children('.customExtensionDiv').children('div').length);
			},
			error : function() {
				alert('삭제 실패');
			}
		});
	});
</script>

</html>