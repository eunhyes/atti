<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="atti.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.nio.file.*" %>
<!-------------------- 
 * 기능 번호  : #32, #47
 * 상세 설명  : 진료 내용 등록(처방,입원)
 * 시작 날짜 : 2024-05-16
 * 담당자 : 김인수, 김지훈, 박혜아, 한은혜
 -------------------->

<!-- Controller layer  -->
<%
	//로그인한 사용자인지 검증
	if(session.getAttribute("loginEmp") == null){
		response.sendRedirect("/atti/view/loginForm.jsp");
		return;
	}
	
	//사용자의 진료 번호 
	int regiNo = Integer.parseInt(request.getParameter("regiNo"));
	
	//디버깅
	System.out.println("regiNo: " + regiNo);
	
%>

<!-- Model layer -->

<% 
	//진료
	
	int petNo = 0;
	String petNoStr = request.getParameter("petNo");
	String clinicError = request.getParameter("clinicError");
	
	if(petNoStr != null) {
		petNo = Integer.parseInt(petNoStr);
	}
	
	
	System.out.println("petNo: " + petNo);
	System.out.println("clinicError: " + clinicError);
	
	ArrayList<HashMap<String, Object>> clinicInfo = ClinicDao.clinicInfo(regiNo);
	ArrayList<HashMap<String, Object>> clinicList = ClinicDao.clinicDetail(petNo);
%>


<% 
	//검사
	// 등록/수정 분기
	String examinationByClinic = request.getParameter("examinationByClinic");
	//System.out.println(examinationByClinic + " ====== clinicDetailForm.jsp examinationByClinic");
	
	// 수정시 가져올 검사 DAO 호출(examinationNo)
	HashMap<String, Object> examinationDetail = new HashMap<String, Object>();
	if(examinationByClinic == null){
		
		examinationByClinic = "";
	
	} else if(examinationByClinic.equals("examinationUpdate")){
		// ArrayList -> HashMap 
		int examinationNo = Integer.parseInt(request.getParameter("examinationNo"));
		System.out.println(examinationNo + " ====== clinicDetailForm.jsp examinationNo");

		ArrayList<HashMap<String, Object>> examinationList = ExaminationDao.examinationDetail(examinationNo);
	   
		if (!examinationList.isEmpty()) {
	        examinationDetail = examinationList.get(0);
	    }	
	}
	// 검사 종류 DAO 호출 
	ArrayList<HashMap<String, Object>> examinationType = ExaminationDao.examinationType();
	//System.out.println(examinationType + " ====== clinicDetailForm.jsp examinationType");

	// 진료 페이지에서 보여줄 검사 DAO 호출(regiNo)
	ArrayList<HashMap<String, Object>> ei = ExaminationDao.examinationInfo(regiNo);
	//System.out.println(ei + " ====== clinicDetailForm.jsp ei");


%>


<% 
	//수술
	String surgeryUpdate = request.getParameter("surgeryUpdate");
	//System.out.println("surgeryUpdate: " + surgeryUpdate);
	
	// 수술 수정을 위해 받는 파라미터값
	String surgeryContent = null;
	String surgeryKind = null;;
	String surgeryState = null;;
	String surgeryDate = null;;
	
	int surgeryNo = 0;
	if (request.getParameter("surgeryNo") != null) {
		surgeryNo = Integer.parseInt(request.getParameter("surgeryNo"));
		System.out.println("surgeryNo: " + surgeryNo);
	}
	String surgeryError = request.getParameter("surgeryError");
	//System.out.println("surgeryError: " + surgeryError);
	
	ArrayList<HashMap<String, String>> surgeryCategory = SurgeryDao.surgeryKind();
	ArrayList<HashMap<String, Object>> surgeryList = SurgeryDao.surgeryDetailByClinic(regiNo);
	
	ArrayList<HashMap<String, Object>> surgeryDetail = null;
	if (surgeryNo != 0) {
		surgeryDetail = SurgeryDao.surgeryDetail(surgeryNo);
	}
%>


<% 
	//처방
	String selectPrescription = request.getParameter("selectPrescription");
	
	//처방 수정버튼을 누를경우 상세 정보를 가져오기
	HashMap<String, Object> prescriptionOne = new HashMap<String, Object>();
	
	if(selectPrescription == null){
		selectPrescription = "";
	}else if(selectPrescription.equals("prescriptionUpdate")){
		
		//수정원하는 처방고유번호에 대한 상세보기 조회
		int prescriptionNo = Integer.parseInt(request.getParameter("prescriptionNo"));
		prescriptionOne = PrescriptionDao.prescrptionOne(regiNo, prescriptionNo);
	}
	
	//약선택을 위해 전체 약 조회
	ArrayList<HashMap<String, Object>> medicineList = PrescriptionDao.medicineList();
	
	//처방 받은 약 정보 전체 조회
	ArrayList<HashMap<String, Object>> prescriptionDetail = PrescriptionDao.prescrptionDetail(regiNo); 
	
	//디버깅
	//System.out.println("clinicDetailForm.jsp medicineList--> "+medicineList);
	//System.out.println("clinicDetailForm.jsp prescriptionDetail--> "+prescriptionDetail);
	//System.out.println("clinicDetailForm.jsp selectPrescription--> "+selectPrescription);
	//System.out.println("clinicDetailForm.jsp prescriptionOne--> "+prescriptionOne);
%>


<%
	//입원
	//사용 가능한 입원실 정보 조회
	ArrayList<HashMap<String, Object>>  hospitalRoomList = HospitalizationDao.hospitalRoomList();

	//진료 번호를 통해 입원 환자 정보 조회 
	HashMap<String, Object> hospitalizationDetail = HospitalizationDao.hospitalizationDetail(regiNo);

	
	//디버깅
	//System.out.println(hospitalRoomList);
	//System.out.println(hospitalizationDetail);
	
	  // 입원 환자 정보가 없는 경우 초기화
	if( hospitalizationDetail == null){
		hospitalizationDetail = new HashMap<>();
	}
	
	//디버깅
	//System.out.println(hospitalizationDetail);
	
%>

<!-- view layer -->
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>진료 상세</title>
	
	<!-- 부트스트랩 -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
	
	<!-- CSS 공통적용CSS파일 -->
	<link rel="stylesheet" href="../css/css_all.css">
	<link rel="stylesheet" href="../css/css_kiminsu.css">
	<link rel="stylesheet" href="../css/css_hyeah.css">
	<link rel="stylesheet" href="../css/css_jihoon.css">
	<link rel="stylesheet" href="../css/css_eunhye.css">
	
</head>
<body id="fontSet">
	
	<!-------------------- header -------------------->
	<jsp:include page="/inc/header.jsp"></jsp:include>

	<!-------------------- aside-------------------->
	<aside>
		<!-- 서브메뉴나오는 부분 -->
		<div id="subMenu">
			<div id="subMenuBtnContainer">
				<button type="button" onclick="location.href='./clinicList.jsp'">진료 조회</button><br><br>
			</div>
		</div>
	</aside>
	
	<!-------------------- main -------------------->
	<main>
		<!-- 상세정보 전체 출력 창(정보가 없을경우 공란표기) -->
		<h5>고객 정보</h5>
		<div id="clinicInfoMainDiv">
			<div id="clinicInfoTitleDiv">
				내용
			</div>
			<!-- 접수/진료 정보 -->
			<div id="clinicInfoLeftDiv">
				<div id="clinicInfoLeftContent">
					<span>펫/보호자 정보</span><br>
				<%
					for(HashMap<String, Object> ci : clinicInfo) {
						String empMajor = (String)ci.get("empMajor");
						if(empMajor.equals("포유류")){
				%>
							<img id="iconAnimal"  src="../inc/icon_dog.png">
				<%
						}else if(empMajor.equals("파충류")){
							%>
							<img id="iconAnimal"  src="../inc/icon_lizard.png">
				<%
						}else if(empMajor.equals("조류")){
				%>
							<img id="iconAnimal"  src="../inc/icon_bird.png">
				<%
						}
				%>
						<div>보호자: <%=(String)(ci.get("customerName"))%></div>
						<div>분류: <%=(String)(ci.get("empMajor"))%></div>
						<div>종류: <%=(String)(ci.get("petKind"))%></div>
						<div>이름: <%=(String)(ci.get("petName"))%></div>
				<%		
					}
				%>
				</div>
			</div>
			<div id="clinicInfoRightDiv">
				<div id="clinicInfoRightContent">
				<span>접수 정보</span><br>
				<%
					for(HashMap<String, Object> ci : clinicInfo) {
				%>
						<div>접수 내용: <%=(String)(ci.get("regiContent"))%></div>
						<div>접수 시간: <%=(String)(ci.get("regiDate"))%></div>
				<%		
					}
				%>
				</div>
			</div>
		</div><br><br>
	
		<!-- 정보등록 및 상세보기 -->
		<h5>정보 등록 및 상세 보기</h5>
		<div id="clinicMainDiv">
			<div id="clinicTitleDiv">
				진료
			</div>
			<!-- 진료 등록 -->
			<div id="clinicContentLeftDiv">
				<span>진료 등록</span>
				<form action="/atti/action/clinicAction.jsp" method="post" id="clinicForm">
					<input type="hidden" value="<%=regiNo%>" name="regiNo"> 
					<input type="hidden" value="<%=petNo%>" name="petNo">
					<input type="datetime-local" id="clinicContentToday" name="clinicContentDate" readonly="readonly">
					<div id="">
						<textarea rows="7" cols="30%" name="clinicContent" placeholder="내용을 입력해 주세요."></textarea><br>
						<%
							if(clinicError != null) {
						%>
								<div id="clinicError"><%=clinicError%></div>
						<%		
							}
						%>
					</div>
					<button type="submit">저장</button>	
				</form>
			</div>
			<div id="clinicContentRightDiv">
				<div id="clinicContentHistory">
				<%
					for (HashMap<String, Object> cl : clinicList) {
						String clinicCon = (String)cl.get("clinicContent");
						if(clinicCon == null){
							clinicCon = "";
						}
						String clinicConChange = clinicCon.replaceAll("\n", "<br/>");
						if(!(clinicCon.equals(""))){
				%>
							<%=clinicConChange%><br>
				<%
						}
					}
				%>
				</div>
			</div>
		</div><br>
		
	<!-- 검사 등록/수정 -->
	
        <div id="examinationMainDiv">
            <div id="examinationTitleDiv">
                검사
            </div>

    <!-- 검사 등록 -->
            <div id="examinationContentLeftDiv">
                <form method="post" action="/atti/action/clinicExaminationAction.jsp" id="examinationForm" enctype="multipart/form-data">
                    <input type="hidden" value="examinationInsert" name="examinationByClinic">
                    <input type="hidden" value="<%=regiNo %>" name="regiNo">
                    <input type="hidden" value="<%=petNo %>" name="petNo">
                    <input type="hidden" value="default.jpg" name="fileNameInsert">
                    
                    <span>검사 등록</span>
                    <br><br>
                    <div>
                        <div class="mb-1">검사 종류</div>
                        <select name="examinationKind">
                            <%
                            	// 검사 종류
                                for(HashMap et : examinationType){
                            %>                    
                                <option value="<%=(String)et.get("examinationKind")%>"> <%=(String)et.get("examinationKind") %></option>
                            <%
                                }
                            %>
                        </select>
                    </div>
                    <br>
                    <div>
                        <div class="mb-1">검사 내용</div>
                        <input type="text" name="examinationContent">
                    </div>
                    <br>
                    <button type="submit">등록</button>
                </form>
            </div>
		
	<!-- 검사 보여주기 -->	
			<div id="examinationContentRightDiv">
			<%
				// 수정이 아닐 때
				if(!examinationByClinic.equals("examinationUpdate")){
			%>
		
				<span>검사 기록</span><br><br>
			<%
				for(HashMap exam : ei){
			%>
			
				<table>
					<tr>
						<th>검사 종류</th>
						<td><%=exam.get("examinationKind")%></td>
						<td rowspan="3">
							<button type="submit" onclick="location.href='/atti/view/clinicDetailForm.jsp?regiNo=<%=regiNo%>&petNo=<%=petNo%>&examinationNo=<%=exam.get("examinationNo")%>&examinationByClinic=examinationUpdate'">
								검사등록
							</button>
						</td>
					</tr>
					<tr>
						<th>내용</th>
						<td>
							<%=exam.get("examinationContent")%>
						</td>
					</tr>
					<tr>
						<th>검사사진</th>
						<td>
							<button><a href="/atti/view/examinationDetail.jsp?examinationNo=<%=exam.get("examinationNo") %>">상세보기</a></button>
						</td>
					</tr>
					<tr>
						<th>검사날짜</th>
						<td><%=exam.get("examinationDate")%></td>
					</tr>
				</table>
			<%
					}
				// 수정일 때 
				} else if(examinationByClinic.equals("examinationUpdate")){
			
			%>
				<form method="post" action="/atti/action/clinicExaminationAction.jsp" enctype="multipart/form-data">
		            <input type="hidden" value="examinationUpdate" name="examinationByClinic">
		            <input type="hidden" value="<%=regiNo %>" name="regiNo">
		            <input type="hidden" value="<%=petNo %>" name="petNo">
					<input type="hidden" value="<%=examinationDetail.get("examinationNo") %>" name="examinationNo">
		
				<table>
					<tr>
	                    <th>검사 종류</th>
	                    <td>
	                        <select name="examinationKind">
	                            <%
	                                for(HashMap et : examinationType){
	                            %>                    
	                                <option value="<%=(String)et.get("examinationKind")%>"> <%=(String)et.get("examinationKind") %></option>
	                            <%
	                                }
	                            %>
	                        </select>
	                    </td>
					</tr>
					<tr>
						<th>내용</th>
						<td>
							<input type="text" name="examinationContent" value="<%=examinationDetail.get("examinationContent")%>">
						</td>
					</tr>
					<tr>
						<th>검사사진</th>
						<td>
							<input type="file" name="fileName" value="<%=examinationDetail.get("fileName") %>">
						</td>
					</tr>
					<tr>
						<th>검사날짜</th>
						<td><%=examinationDetail.get("examinationDate")%></td>
					</tr>
					<tr>
						<td colspan="4"><button type="submit">등록완료</button></td>
					</tr>
				</table>
				</form>
				<%
					}
				%>
			</div>
		</div><br>
		
		
		<div id="surgeryMainDiv">
			<div id="surgeryTitleDiv">
				수술	
			</div>
			
			<!-- 수술: 수술 신규 등록 -->
			<div id="surgeryContentLeftDiv">
				<span>수술 신규 등록</span><br><br>
				<%
					if(surgeryList.isEmpty() && surgeryUpdate == null){
				%>
					<form action="/atti/action/clinicSurgeryAction.jsp" method="post" id="surgeryForm">
						<input type="hidden" value="<%=regiNo%>" name="regiNo">
						<input type="hidden" value="<%=petNo%>" name="petNo">
						<input type="hidden" value="surgeryInsert" name="surgeryInsert">
						
						<div id="">
							<!-- 수술 종류를 선택 -->
							<div><h6>수술 선택</h6></div>
								<select name="surgeryKind">
									<option value="">===수술===</option>
									<%
										for(HashMap<String, String> sc : surgeryCategory) {
									%>
											<option value="<%=sc.get("surgeryKind")%>"><%=sc.get("surgeryKind")%></option>
									<%	  
										}
									%>
								</select><br><br>
								
							<!-- 수술 내용 등록 -->
							<div><h6>수술 내용</h6></div>
							<input type="text" name="surgeryContent"><br><br>
							<input type="datetime-local" name="surgeryDate"><br><br>
							<%
								if(surgeryError != null){
							%>
									<div class="surgeryError"><%=surgeryError%></div>						
							<%
								}
							%>
							<button type="submit">저장</button>
						</div>
					</form>
				<%
					}
				%>
			</div>

			<div id="surgeryContentRightDiv">
			<%
				/* 수술 내용 조회 */
				if(surgeryUpdate == null && !surgeryList.isEmpty()){
			%>
						<span>수술 이력</span><br><br>
				<%
						for(HashMap<String, Object> sl : surgeryList){
				%>
							<table>
								<tr>
									<th>수술</th>
									<td><%=sl.get("surgeryKind")%></td>
									<td rowspan="3">
										<form method="post" action="/atti/view/clinicDetailForm.jsp">
											<input type="hidden" name="surgeryUpdate" value="surgeryUpdate"> 
											<input type="hidden" name="petNo" value="<%=petNo%>" >
											<input type="hidden" name="regiNo" value="<%=sl.get("regiNo")%>">										
											<input type="hidden" name="surgeryNo" value="<%=sl.get("surgeryNo")%>">											
											<button type="submit">
												수정
											</button>
										</form>
									</td>
								</tr>
								<tr>
									<th>수술 내용</th>
									<td>
										<%=sl.get("surgeryContent")%>
									</td>
								</tr>
								<tr>
									<th>수술 날짜</th>
									<td><%=sl.get("surgeryDate")%></td>
								</tr>
							</table>
					<%
						}
						
					/* 수술 수정 */
					} else if(surgeryUpdate != null && !surgeryList.isEmpty()){
						HashMap<String, Object> sd = surgeryDetail.get(0); 
						surgeryKind = (String) sd.get("surgeryKind");
						surgeryContent = (String) sd.get("surgeryContent");
						surgeryState = (String) sd.get("surgeryState");
						surgeryDate = (String) sd.get("surgeryDate");
				%>
						<form action="/atti/action/clinicSurgeryAction.jsp" method="post">
							<span>수술 수정</span>
							<input type="hidden" value="surgeryUpdate" name="surgeryUpdate">
							<input type="hidden" value="<%=surgeryNo%>" name="surgeryNo">
							<input type="hidden" value="<%=petNo%>" name="petNo"  >
							<input type="hidden" value="<%=regiNo%>" name="regiNo">
							
							<table>
								<tr>
									<th>수술</th>
									<td>
										<select name="surgeryKind" readonly="readonly">
											<option value="">===수술===</option>
											 <%
			                                    for(HashMap<String, String> sc : surgeryCategory) {
			                                        String kind = sc.get("surgeryKind");
			                                %>
			                                    <option value="<%=kind%>" <%=kind.equals(surgeryKind) ? "selected" : "" %>>
			                                        <%=kind%>
			                                    </option>
			                                <%	  
			                                    }
			                                %>
										</select>
									</td>
								</tr>
								<tr>
									<th>수술 내용</th>
									<td>
										<input type="text" value="<%=surgeryContent%>" name="surgeryContent">
									</td>
								</tr>
								<tr>
									<th>수술 날짜</th>
									<td><input type="datetime-local" value="<%=surgeryDate%>" name="surgeryDate" readonly="readonly"></td>
								</tr>
								<tr>
									<td colspan="4"><button type="submit">수정 완료</button></td>
								</tr>
								<%
									if(surgeryError != null){
								%>
										<div class="surgeryError"><%=surgeryError%></div>										
								<%	
									}
								%>
							</table>
						</form>
				<%	
					}
				%>
			</div>
		</div><br>
		
		<!-- 처방 조회/신규등록/수정 -->
		<div id="prescrptionMainDiv">
			<div id="prescrptionTitleDiv">
				처방	
			</div>
			
			<!-- 처방방: 약 신규등록 -->
			<div id="prescrptionContentLeftDiv">
				<span>약 신규 등록</span><br><br>
				<form action="/atti/action/clinicPrescrptionAction.jsp" method="post" id="prescriptionForm">
					<input type="hidden" value="<%=regiNo%>" name="regiNo">
					<input type="hidden" value="<%=petNo%>" name="petNo">
					<input type="hidden" value="prescriptionInsert" name="selectPrescription">
					
					<div id="">
						<!-- 처방받을 약코드를 선택 -->
						<div><h6>약 선택</h6></div>
							<select name="medicineNo">
								<%
									for(HashMap mc : medicineList){
								%>
										<option value="<%=(Integer)mc.get("medicineNo")%>">
											<%=(String)mc.get("medicineName")%>
										</option>
								<%	
									}
								%>
							</select><br><br>
							
						<!-- 선택된 약코드에대한 처방내용 등록 -->
						<div><h6>처방내용</h6></div>
						<input name="prescriptionContent"><br><br>
						
						<button type="submit">저장</button>
					</div>
				</form>
			</div>
			
			<div id="prescrptionContentRightDiv">
				<%
					/* 처방: 처방받은 약 전체 조회 */
					if(!selectPrescription.equals("prescriptionUpdate")){
				%>
						<span>처방받은 약</span><br><br>
				<%
						for(HashMap pd2 : prescriptionDetail){
				%>
							<table>
								<tr>
									<th>약</th>
									<td><%=pd2.get("medicineName")%></td>
									<td rowspan="3">
										<button type="submit" 
											onclick="location.href='/atti/view/clinicDetailForm.jsp?regiNo=<%=regiNo%>&petNo=<%=petNo%>&prescriptionNo=<%=pd2.get("prescriptionNo")%>&selectPrescription=prescriptionUpdate'">
											수정
										</button>
									</td>
								</tr>
								<tr>
									<th>내용</th>
									<td>
										<%=pd2.get("prescriptionContent")%>
									</td>
								</tr>
								<tr>
									<th>처방날짜</th>
									<td><%=pd2.get("prescriptionDate")%></td>
								</tr>
							</table>
				<%
						}
						
					/* 처방: 수정원하는 약 1개 선택 후 수정 */
					}else if(selectPrescription.equals("prescriptionUpdate")){
				%>
						<form action="/atti/action/clinicPrescrptionAction.jsp" method="post">
							<span>처방 수정</span>
							
							<input type="hidden" value="prescriptionUpdate" name="selectPrescription">
							<input type="hidden" value="<%=prescriptionOne.get("prescriptionNo")%>" name="prescriptionNo">
							<input type="hidden" value="<%=prescriptionOne.get("medicineNo")%>" name="oldMedicineNo">
							<input type="hidden" value="<%=regiNo%>" name="regiNo">
							<input type="hidden" value="<%=petNo%>" name="petNo">
							
							<table>
								<tr>
									<th>약</th>
									<td>
										<select name="newMedicineNo">
									<%
											for(HashMap mc : medicineList){
												int medicineNo1 = (Integer)mc.get("medicineNo");
												int medicineNo2 = (Integer)prescriptionOne.get("medicineNo");
									%>
												<option value="<%=medicineNo1%>" <%= medicineNo1==medicineNo2 ? "selected" : ""%>>
													<%=(String)mc.get("medicineName")%>
												</option>
									<%	
											}
									%>
										</select>
									</td>
								</tr>
								<tr>
									<th>내용</th>
									<td>
										<input type="text" value="<%=prescriptionOne.get("prescriptionContent")%>" name="prescriptionContent">
									</td>
								</tr>
								<tr>
									<th>처방날짜</th>
									<td><%=prescriptionOne.get("prescriptionDate")%></td>
								</tr>
								<tr>
									<td colspan="4"><button type="submit">수정완료</button></td>
								</tr>
							</table>
						</form>
				<%
					}
				%>
			</div>
		</div><br>
		
		<!-- 입원 환자 호실 선택 및 입원 내용 입력 폼 -->
		<form action="/atti/action/clinicHospitalAction.jsp" method="post" id="hospitalizationRegiForm">			
			<input type="hidden" value="<%=regiNo%>" name="regiNo">
			<input type="hidden" value="<%=petNo%>" name="petNo"  >
			<input type="hidden" value="입원" name="paymentCategory">

			<div id="hospitalizationTitleDiv">
				입원			
			</div>
			
			<div id="animalSelectBoxDiv">
				
				<%
					//입원실 정보 유무에 따라 다른 처리
					if(("퇴원".equals(hospitalizationDetail.get("state")) || (hospitalizationDetail.get("state") == null))){
				  		String empMajor = (String) hospitalizationDetail.get("empMajor");
                        String roomName = (String) hospitalizationDetail.get("roomName");
                        
                        //디버깅
                        //System.out.println("roomName = " + roomName);
                        //System.out.println("empMajor = " + empMajor);
				%>
					<div>호실 선택</div>
				
					<%
						if("포유류".equals(empMajor)){ 
					%>
						<!-- 포유류 입원실 침대 선택하기 -->
						<select name="mammalRoom">
							<%
								for(HashMap<String, Object> room : hospitalRoomList){
									String roomNames = (String) room.get("room_name");
                                    if(roomNames.startsWith("A")) {
							%>
										<option value="<%= roomNames %>"><%= roomNames %></option>
							<%
                                    }
								}
							%>
						</select>				
					<%
						}else if("파충류".equals(empMajor)){
					%>
						<!-- 파충류 입원실 침대 선택하기 -->
						<select name="reptilesRoom">
							<%
								for(HashMap<String, Object> room : hospitalRoomList){
									String roomNames = (String) room.get("room_name");
                                    if(roomNames.startsWith("B")) {
							%>
										<option value="<%= roomNames %>"><%= roomNames %></option>
							<%
                                    }
								}
							%>
						</select>
					<%	
						}else{
					%>
						<!-- 조류 입원실 침대 선택하기 -->
						<select name="birdRoom">
							<%
								for(HashMap<String, Object> room : hospitalRoomList){
									String roomNames = (String) room.get("room_name");
                                    if(roomNames.startsWith("C")) {
							%>
										<option value="<%= roomNames %>"><%= roomNames %></option>
							<%
                                    }
								}
							%>
						</select>					
					<%
						}
					%>
					<input type="hidden" name="state" value="<%=hospitalizationDetail.get("state")%>">
					<button type="submit">저장</button>
			
				<%		
					}else{	
				%>
					<div>
						<div>
							<%=hospitalizationDetail.get("empMajor")%> / 
							<%=hospitalizationDetail.get("petName")%>
						</div>
						<div>
							"<%=hospitalizationDetail.get("roomName")%>" 입원중
						</div>
						<div>
							입원일: 
							<%
								if(hospitalizationDetail.get("createDate") != null){
							%>							
								<%=hospitalizationDetail.get("createDate").toString().substring(0,10)%>
							<%
								}
							%>
						</div>
						<div>
							퇴원일: 
							<%
								if(hospitalizationDetail.get("dischargeDate") != null){
							%>
								<%=hospitalizationDetail.get("dischargeDate").toString().substring(0,10)%>								
							<%
								}
							%>
						</div>
					</div>
				<%
					}
				%>
			</div>
		</form>
<script>
  var userTimezoneOffset = new Date().getTimezoneOffset() * 60000;
  var localTime = new Date(Date.now() - userTimezoneOffset);
  var localISOString = localTime.toISOString().slice(0, -1);
  document.getElementById('clinicContentToday').value = localISOString.slice(0, 16);
</script>		
	</main>
</body>
</html>