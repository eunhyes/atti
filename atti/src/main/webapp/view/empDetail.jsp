<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="atti.*" %>

<!-------------------- 
 * 기능 번호  : #11
 * 상세 설명  : 직원 상세보기 페이지(사번, 이름, 생년월일, 성별, 전화번호, 입사일, 전공, 직책)
 * 시작 날짜 : 2024-05-13
 * 담당자 : 김인수
 -------------------->

<!-- Controller layer  -->
<%
	//세션을 변수로 변환
	HashMap<String, Object> loginEmp = (HashMap<String, Object>)session.getAttribute("loginEmp");
	
	//로그인한 사용자가 관리자인지 확인
	if(loginEmp == null || (loginEmp != null && loginEmp.get("empNo").toString().charAt(0) != '1')){
		response.sendRedirect("/atti/view/main.jsp"); // 로그인하지 않은 사용자는 로그인 페이지로 이동
		return;
	}
	
	//디버깅
	//System.out.println(loginEmp);
	
	//직원의 사번
	int empNo = Integer.parseInt(request.getParameter("empNo"));
	
	//디버깅
	//System.out.println(empNo);
	
%>

<!-- Model layer -->
<%
	//선택된 회원의 정보 가져오기(사번, 이름, 생년월일, 성별, 전화번호, 입사일, 전공, 직책)
	ArrayList<HashMap<String, Object>> detailList = EmpDao.empDetail(empNo);
	
	//디버깅
	//System.out.println("detailList = " + detailList);
%>

 
<!-- view layer -->
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>empDetail page</title>
	
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
		<jsp:include page="/inc/empSubMenu.jsp"></jsp:include>
	</aside>
	
	<!-------------------- main -------------------->
	<main>
		<h2>개인정보</h2>
		<div id="detailDiv">
		
			<%
				for(HashMap<String, Object> m : detailList){
			%>
				<div class="contentDiv">
					<label>사번</label>
					<%=(String)(m.get("empNo"))%>
				</div>
				
				<div class="contentDiv">
					<label>전공</label>
					<%=(String)(m.get("empMajor"))%>
				</div>
				<div class="contentDiv">
					<label>직책</label>	
					<%=(String)(m.get("empGrade"))%></div>
				<div class="contentDiv">
					<label>이름</label>
					<%=(String)(m.get("empName"))%>
				</div>
				<div class="contentDiv">
					<label>생일</label>
					<%=(String)(m.get("empBirth"))%>
				</div>
				<div class="contentDiv">
					<label>성별</label>
					<%=(String)(m.get("empGender"))%>
				</div>
				<div class="contentDiv">
					<label>전화번호</label>
					<%=(String)(m.get("empTel"))%>
				</div>
			<%
				}
			%>
			
			<div id="detailBtn">
				<button class="detailEmpBtn">
					<a href="/atti/view/empList.jsp">뒤로가기</a>
				</button>
				<button class="detailEmpBtn">
					수정하기
				</button>
			</div>
			
		</div>
	</main>
</body>
</html>