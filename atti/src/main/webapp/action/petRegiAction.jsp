<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="atti.*"%>   
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<!-------------------- 
 * 기능 번호  : #21
 * 상세 설명  : 펫 정보 등록 페이지(액션)
 * 시작 날짜 : 2024-05-13
 * 담당자 : 김지훈
 -------------------->
 
<%
	System.out.println("--------------------");
	System.out.println("petRegiAction.jsp");
%>
<!-- Controller layer  -->
<%
	/* // 로그인한 사용자가 관리자인지 확인
	// 세션을 변수로 변환
	HashMap<String, Object> loginEmp = (HashMap<String, Object>)session.getAttribute("loginEmp");
	// 관리자, 직원 여부에 따라 보여지는 뷰가 달라짐
	if(loginEmp == null || (loginEmp != null && loginEmp.get("empNo").toString().charAt(0) != '1')){
		response.sendRedirect("/atti/view/main.jsp"); // 로그인하지 않은 사용자는 로그인 페이지로 이동
		return;
	} */
	
	// petRegiForm -> petRegiAction
	int customerNo = Integer.parseInt(request.getParameter("customerNo"));
	String major = request.getParameter("major");
	String petKind = request.getParameter("petKind");
	String petName = request.getParameter("petName");
	String petBirth = request.getParameter("petBirth");
	
	// form -> action 파라미터값 확인
	//System.out.println("customerNo: " + customerNo);
	//System.out.println("major: " + major);
	//System.out.println("petKind: " + petKind);
	//System.out.println("petName: " + petName);
	//System.out.println("petBirth: " + petBirth);
	
	String errorMsg = null;
	
	if(major == null || major.trim().isEmpty()) {
		errorMsg = URLEncoder.encode("의사 전공이 입력되지 않았으니 확인해 주세요", "UTF-8");
	} else if(petKind == null || petKind.trim().isEmpty()) {
		errorMsg = URLEncoder.encode("동물 종류가 입력되지 않았으니 확인해 주세요", "UTF-8");
	} else if(petName == null || petName.trim().isEmpty()) {
		errorMsg = URLEncoder.encode("이름이 입력되지 않았으니 확인해 주세요", "UTF-8");
	} else if(petBirth == null || petBirth.trim().isEmpty()) {
		errorMsg = URLEncoder.encode("생일이 입력되지 않았으니 확인해 주세요", "UTF-8");
	}	
%>
<!-- model layer -->
<%
	if(errorMsg == null) {
		int insertRow = PetDao.petRegistration(customerNo, major, petKind, petName, petBirth);
		if(insertRow > 0) {
			System.out.println("펫 등록 성공");
			response.sendRedirect("/atti/view/customerDetail.jsp?customerNo=" + customerNo);
		} else {
			System.out.println("펫 등록 실패");
			response.sendRedirect("/atti/view/petRegiForm.jsp?customerNo=" + customerNo + "&" + "errorMsg=" + errorMsg);
		} 
	} else {
		System.out.println("펫 등록 실패");
		response.sendRedirect("/atti/view/petRegiForm.jsp?customerNo=" + customerNo + "&" + "errorMsg=" + errorMsg);
	} 
%>