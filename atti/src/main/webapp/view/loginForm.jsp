<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-------------------- 
 * 기능 번호  : #1
 * 상세 설명  : 로그인 페이지(사번, 비밀번호 입력)
 * 시작 날짜 : 2024-05-10
 * 담당자 : 김인수
 -------------------->
 
<!-- Controller layer  -->
<%
	//사번 입력 오류 시 표시될 메세지 
	String nullErrorMessage = request.getParameter("errorMessage");
	String errorMessage = null;

	//사번 입력 오류 시 에러 메세지 
	if(nullErrorMessage != null && !nullErrorMessage.equals("null")){
 		errorMessage = request.getParameter("errorMessage"); 		
	}
	
	//사용자의 회원 정보가 일치하지 않는 경우 에러 메시지
	if(nullErrorMessage != null && nullErrorMessage.equals("null")){
		errorMessage = "회원 정보를 확인하세요.";
	}
	
	//디버깅
	//System.out.println("nullErrorMessage = " + nullErrorMessage);
	//System.out.println("errorMessage = " + errorMessage);

%>
 
<!-- view layer -->
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>로그인 페이지</title>
	
	<!-- 부트스트랩 -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
	
	<!-- CSS 공통적용CSS파일 -->
	<link rel="stylesheet" href="../css/css_all.css">
	<link rel="stylesheet" href="../css/css_kiminsu.css">
	
</head>
<body id="fontSet">
	
	<!-------------------- header -------------------->
	<jsp:include page="/inc/header.jsp"></jsp:include>

	<!-------------------- aside-------------------->
	<aside>
		<!-- 서브메뉴나오는 부분 -->
		<jsp:include page="/inc/subMenu.jsp"></jsp:include>
	</aside>
	
	<!-------------------- main -------------------->
	<main class="userFormMain">
		<div class="userFormDiv">
			<h2>로그인</h2>
			<form action="/atti/action/loginAction.jsp" method="post" >
				<div class="inputDiv">
					<label>아이디</label>
					<input type="text" name="empNo" value="1100802">
				</div>
				<div class="inputDiv">
					<label>비밀번호</label>
					<input type="password" name="empPw" value="1234">
				</div>
				<button type="submit">확인</button>
				
				<%
					//애러 메세지 출력
					if(errorMessage != null){
				%>
						<div id="errorMessageDiv">
							<%=errorMessage%>
						</div>
				<%	
					}
				%>
			</form>
		</div>
	</main>
</body>
</html>