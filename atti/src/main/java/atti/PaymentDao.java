package atti;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

public class PaymentDao {
	
	
	/*
	 * 메소드		: #paymentList(String selectState, int startRow, int rowPerPage)
	 * 페이지		: paymentList.jsp
	 * 시작 날짜	: 2024-05-15
	 * 담당자		: 박혜아
	*/
	public static ArrayList<HashMap<String, Object>> paymentList(String selectState, int startRow, int rowPerPage) throws Exception{
		ArrayList<HashMap<String, Object>> list = new ArrayList<>();
		
		System.out.println("PaymentDao#paymentList() startRow --> "+startRow);
		System.out.println("PaymentDao#paymentList() rowPerPage --> "+rowPerPage);
		System.out.println("PaymentDao#paymentList() selectState변경전 --> "+selectState);
		// 전체 선택일경우 공백처리 
		if(selectState.equals("전체")) {
			selectState = "";
		}
		System.out.println("PaymentDao#paymentList() selectState변경후 --> "+selectState);
		
		//DB연결
		Connection conn = DBHelper.getConnection();
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		/* SELECT(조회화면에서 보여줄 것)
		 * pet : 동물이름
		 * payment : 접수번호, 결제상태, 생성날짜
		*/
		String sql = "SELECT pm.regi_no regiNo, p.pet_name petName, pm.payment_state paymentState, pm.create_date createDate, COUNT(*) OVER() totalRow"
				+ " FROM payment pm"
				+ " INNER JOIN registration r ON r.regi_no = pm.regi_no" //접수의 접수번호 = 결제의 접수번호
				+ " INNER JOIN pet p ON r.pet_no = p.pet_no"			//레지의 동물번호 = 동물의 동물번호
				+ " WHERE pm.payment_state LIKE ?"
				+ " GROUP BY pm.regi_no, pm.payment_state, pm.create_date" 			
				+ " ORDER BY pm.create_date DESC"						//최신순으로 정렬
				+ " LIMIT ?, ?"; 					
		
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, "%"+selectState+"%");
		stmt.setInt(2, startRow);
		stmt.setInt(3, rowPerPage);
		//System.out.println("PaymentDao#paymentList() stmt --> "+stmt);
		
		rs = stmt.executeQuery();
		
		while(rs.next()) {
			HashMap<String, Object> map = new HashMap<>();
			map.put("regiNo", rs.getInt("regiNo"));					//접수번호
			map.put("petName", rs.getString("petName"));			//동물이름
			map.put("paymentState", rs.getString("paymentState"));	//결제상태
			map.put("createDate", rs.getString("createDate"));		//생성날짜
			map.put("totalRow", rs.getInt("totalRow"));				//페이징totalRow
			
			list.add(map);
		}
		
		conn.close();
		return list;
	}
	
	
	/*
	 * 메소드		: #paymentDetail(int regiNo)
	 * 페이지		: paymentDetail.jsp
	 * 시작 날짜	: 2024-05-15
	 * 담당자		: 박혜아
	*/
	public static HashMap<String, Object> paymentDetail(int regiNo) throws Exception{
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		//받아온 값 디버깅
		//System.out.println("PaymentDao#paymentDetail() regiNo --> "+regiNo);
		
		//DB연결
		Connection conn = DBHelper.getConnection();
		PreparedStatement stmt = null;
		ResultSet rs = null;
				
		/* SELECT(조회화면에서 보여줄 것)
		 * pet, customer : 동물이름, 보호자이름 
		 * payment : 접수번호
		 * 그 외 모든 결제정보(진료/검사/수술/입원/처방)
		*/
		String sql = "SELECT pay.regi_no regiNo"
				+ " , pet.pet_name petName" 
				+ " , c.customer_name customerName"
				+ " , pay.payment_state paymentState"
				+ " , cn.clinic_cost clinicCost"
				+ " , GROUP_CONCAT(DISTINCT  ek.examination_kind SEPARATOR ', ') examinationKind"
				+ " , SUM(DISTINCT ek.examination_cost) examinationCost"
				+ " , sg.surgery_kind surgeryKind"
				+ " , sk.surgery_cost surgeryCost"
				+ " , hr.room_name hospitalRoom"
				+ " , hr.cost hospitalCost"
				+ " , GROUP_CONCAT(DISTINCT md.medicine_name SEPARATOR ', ') medicineName"
				+ " , SUM(DISTINCT md.medicine_cost) medicineCost"
				+ " FROM payment pay"
				+ " INNER JOIN registration regi ON pay.regi_no = regi.regi_no" 				// 결제의 접수번호 = 접수의 접수번호
				+ " INNER JOIN pet pet ON regi.pet_no = pet.pet_no" 							// 접수의 동물번호 = 동물의 동물번호
				+ " INNER JOIN customer c ON pet.customer_no = c.customer_no" 					// 동물의 보호자번호 = 보호자의 보호자번호
				+ " LEFT JOIN clinic cn ON pay.regi_no = cn.regi_no" 							// 결제의 접수번호 = 진료의 접수번호
				+ " LEFT JOIN examination ex ON pay.regi_no = ex.regi_no" 						// 결제의 접수번호 = 검사의 접수번호
				+ " LEFT JOIN examination_kind ek ON ex.examination_kind = ek.examination_kind" // 검사의 검사종류 = 검사종류의 검사종류
				+ " LEFT JOIN surgery sg ON pay.regi_no = sg.regi_no" 							// 결제의 접수번호 = 수술의 접수번호
				+ " LEFT JOIN surgery_kind sk ON sg.surgery_kind = sk.surgery_kind" 			// 수술의 수술종류 = 수술종류의 수술종류
				+ " LEFT JOIN hospitalization hp ON pay.regi_no = hp.regi_no" 					// 결제의 접수번호 = 입원의 접수번호
				+ " LEFT JOIN hospital_room hr ON hp.room_name = hr.room_name" 					// 입원의 입원호실 = 입원호실의 입원호실
				+ " LEFT JOIN prescription ps ON regi.regi_no = ps.regi_no" 					// 결제의 접수번호 = 처방의 접수번호
				+ " LEFT JOIN medicine md ON ps.medicine_no = md.medicine_no" 					// 처방의 약번호 = 약의 약번호
				+ " WHERE pay.regi_no = ?"
				+ " GROUP BY pay.regi_no, pet.pet_name, c.customer_name, pay.payment_state, cn.clinic_cost, sg.surgery_kind";
				
		
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, regiNo);
		//System.out.println("PaymentDao#paymentDetail() stmt --> "+stmt);
		
		rs = stmt.executeQuery();
		
		if(rs.next()) {
			map = new HashMap<>();
			map.put("regiNo", rs.getInt("regiNo"));							//접수번호
			map.put("petName", rs.getString("petName"));					//동물이름
			map.put("customerName", rs.getString("customerName"));			//보호자이름
			map.put("paymentState", rs.getString("paymentState"));			//결제상태
			map.put("clinicCost", rs.getInt("clinicCost"));					//진료비용
			map.put("examinationKind", rs.getString("examinationKind"));	//검사종류
			map.put("examinationCost", rs.getInt("examinationCost"));		//검사비용
			map.put("surgeryKind", rs.getString("surgeryKind"));			//수술종류
			map.put("surgeryCost", rs.getInt("surgeryCost"));				//수술비용
			map.put("hospitalRoom", rs.getString("hospitalRoom"));			//입원실
			map.put("hospitalCost", rs.getInt("hospitalCost"));				//입원비용
			map.put("medicineName", rs.getString("medicineName"));			//약이름
			map.put("medicineCost", rs.getInt("medicineCost"));				//약비용
		}
		
		//System.out.println("PaymentDao#paymentDetail() map--> "+map);
		
		conn.close();
		return map;
	}
	
	
	
	/*
	 * 메소드		: #paymentStateUpdate(int regiNo)
	 * 페이지		: paymentDetail.jsp
	 * 시작 날짜	: 2024-05-16
	 * 담당자		: 박혜아
	*/
	public static int paymentStateUpdate(int regiNo, String paymentState) throws Exception{
		int updateRow = 0;
		
		//받아온 값 디버깅
		System.out.println("PaymentDao#paymentStateUpdate() regiNo--> "+regiNo);
		System.out.println("PaymentDao#paymentStateUpdate() paymentState변경전--> "+paymentState);
		
		//진료상태변경에 실패할 수 있으므로 '완납<->미납'으로 변경가능하게 설정
		if(paymentState.equals("완납")) {
			paymentState = "미납";
		}else if(paymentState.equals("미납")) {
			paymentState = "완납";
		}
		System.out.println("PaymentDao#paymentStateUpdate() paymentState변경후--> "+paymentState);
		
		//DB연결
		Connection conn = DBHelper.getConnection();
		PreparedStatement stmt = null;
		
		// '미납' -> '완납'으로 상태변경
		String sql = "UPDATE payment"
				+ " SET payment_state = ?"
				+ " WHERE regi_no = ?";
		
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, paymentState);
		stmt.setInt(2, regiNo);
		
		System.out.println("PaymentDao#paymentStateUpdate() stmt --> "+stmt);
		
		updateRow = stmt.executeUpdate();
		System.out.println("PaymentDao#paymentStateUpdate() updateRow --> "+updateRow);
		
		conn.close();
		return updateRow;
	}
	
	/*
	 * 메소드		: #income(String year, String month)
	 * 페이지		: income.jsp
	 * 시작 날짜	: 2024-05-17
	 * 담당자		: 박혜아
	*/
	public static HashMap<String, Integer> income(String year, String month) throws Exception{
		HashMap<String, Integer> map = new HashMap<>();
		
		// 값 디버깅
		//System.out.println("PaymentDao#income() year--> "+year);
		//System.out.println("PaymentDao#income() month--> "+month);
		
		//DB연결
		Connection conn = DBHelper.getConnection();
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		/* SELECT(조회화면에서 보여줄 것)
		 * pay : 해당하는 년도/달의 각 매출액 및 총 매출액 (null일 경우 0으로 치환 후 계산)
		*/
		String sql = "SELECT IFNULL(sum(cn.clinic_cost), 0) clinicSum,"
				+ " IFNULL(sum(ek.examination_cost), 0) examinationSum,"
				+ " IFNULL(sum(sk.surgery_cost), 0) surgerySum,"
				+ " IFNULL(sum(hr.cost), 0) hospitalSum,"
				+ " IFNULL(sum(md.medicine_cost), 0) medicineSum,"
				+ " IFNULL(sum(cn.clinic_cost),0)+IFNULL(sum(ek.examination_cost), 0)+IFNULL(sum(sk.surgery_cost), 0)+IFNULL(sum(hr.cost), 0)+IFNULL(sum(md.medicine_cost), 0) monthSum"
				+ " FROM payment pay"
				+ " INNER JOIN registration regi ON pay.regi_no = regi.regi_no"
				+ " INNER JOIN pet pet ON regi.pet_no = pet.pet_no"
				+ " INNER JOIN customer c ON pet.customer_no = c.customer_no"
				+ " LEFT JOIN clinic cn ON pay.regi_no = cn.regi_no"
				+ " LEFT JOIN examination ex ON pay.regi_no = ex.regi_no"
				+ " LEFT JOIN examination_kind ek ON ex.examination_kind = ek.examination_kind"
				+ " LEFT JOIN surgery sg ON pay.regi_no = sg.regi_no"
				+ " LEFT JOIN surgery_kind sk ON sg.surgery_kind = sk.surgery_kind"
				+ " LEFT JOIN hospitalization hp ON pay.regi_no = hp.regi_no"
				+ " LEFT JOIN hospital_room hr ON hp.room_name = hr.room_name"
				+ " LEFT JOIN prescription ps ON regi.regi_no = ps.regi_no"
				+ " LEFT JOIN medicine md ON ps.medicine_no = md.medicine_no"
				+ " WHERE pay.payment_state = '완납'"
				+ " AND DATE_FORMAT(pay.create_date, '%Y-%m') = ?";
		
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, year + "-" + month);
		//stmt.setString(1, year);
		//stmt.setString(2, month);
		System.out.println("PaymentDao#income() stmt--> "+stmt);
		
		rs = stmt.executeQuery();
		
		if(rs.next()) {
			map = new HashMap<>();
			map.put("clinicSum", rs.getInt("clinicSum"));
			map.put("examinationSum", rs.getInt("examinationSum"));
			map.put("surgerySum", rs.getInt("surgerySum"));
			map.put("hospitalSum", rs.getInt("hospitalSum"));
			map.put("medicineSum", rs.getInt("medicineSum"));
			map.put("monthSum", rs.getInt("monthSum"));
			
		}
		//System.out.println("PaymentDao#income() map--> "+map);
		//System.out.println("===================================");
		
		conn.close();
		return map;
	}
	
	
	
	/*
	  	메소드: payment#paymentInsert()
	  	
	  	페이지: clinicAtcion.jsp, clinicSurgeryAction.jsp , 
  			  clinicPrescrptionAction.jsp, clinicExaminationAction.jsp
  			  clinicHospitalAction.jsp
	  			
	  	시작날짜: 2024-05-22
	  	담당자: 김인수, 김지훈, 박헤아, 한은혜
	*/
	public static int paymentInsert(int regiNo, String paymentCategory) throws Exception{
		
		//매개변수 값 출력
		//System.out.println("regeNo = " + regeNo);
		//System.out.println("paymentCategory = " + paymentCategory);
		
		//반환 값 변수
		int insertRow = 0;
		
		PreparedStatement stmt = null;
		
		//DB연결  
		Connection conn = DBHelper.getConnection();
		
		//결제 정보 저장: 환자가 이용한 서비스(수술, 처방, 진료, 검사, 입원) 
		String sql = "INSERT INTO payment(regi_no, payment_category, create_date) "
				+ "VALUES (?,?,NOW())";
		
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1,regiNo); // 접수 번호
		stmt.setString(2, paymentCategory); // 환자가 이용한 서비스(수술, 처방, 진료, 검사, 입원)
		
		insertRow = stmt.executeUpdate();
		
		conn.close();
		return insertRow;
	}
	
	
	/*
	  	메소드: payment#paymentSelect()
	  	
	  	페이지: clinicAtcion.jsp, clinicSurgeryAction.jsp , 
			  clinicPrescrptionAction.jsp, clinicExaminationAction.jsp
			  clinicHospitalAction.jsp
	  			
	  	시작날짜: 2024-05-22
	  	담당자: 김인수
	*/
	public static HashMap<String, Object> paymentSelect(int regiNo, String paymentCategory) throws Exception{
		
		//매개변수 값 출력
		//System.out.println("regeNo = " + regeNo);
		//System.out.println("paymentCategory = " + paymentCategory);
		
		//반환 값 변수
		HashMap<String, Object> resultMap = null;
		
		PreparedStatement stmt = null;
		ResultSet rs = null; 
		
		//DB연결 
		Connection conn = DBHelper.getConnection();
		
		//결제 정보 조회: 같은 접수번호에 환자가 이용한 서비스(수술, 처방, 진료, 검사, 입원) 중 중복이 있는지 조회 
		String sql = "SELECT payment_no FROM payment WHERE regi_no = ? AND payment_category = ?";
		
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1,regiNo); // 접수 번호
		stmt.setString(2, paymentCategory); // 환자가 이용한 서비스(수술, 처방, 진료, 검사, 입원)
		
		rs = stmt.executeQuery();
		
		if(rs.next()) {
			resultMap = new HashMap<String, Object>();
			resultMap.put("paymentNo",rs.getInt("payment_no")); 
		}
		
		
		conn.close();
		return resultMap;
	}
	
	
	/*
	  	메소드: payment#paymentUpdate()
	  	
	  	페이지: clinicAtcion.jsp, clinicSurgeryAction.jsp , 
			  clinicPrescrptionAction.jsp, clinicExaminationAction.jsp
			  clinicHospitalAction.jsp
	  			
	  	시작날짜: 2024-05-22
	  	담당자: 김인수
	*/
	public static int paymentUpdate(int regiNo, String paymentCategory) throws Exception{
			
			//매개변수 값 출력
			//System.out.println("regeNo = " + regeNo);
			//System.out.println("paymentCategory = " + paymentCategory);
			
			//반환 값 변수
			int updateRow = 0;
			
			PreparedStatement stmt = null;
			
			//DB연결 
			Connection conn = DBHelper.getConnection();
			
			//결제 정보 수정: 같은 접수번호에 환자가 이용한 서비스(수술, 처방, 진료, 검사, 입원)가 중복이 있는 경우 수정 
			String sql = "UPDATE payment SET create_date = NOW() "
					+ "WHERE regi_no = ? AND payment_category = ?";
			
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1,regiNo); // 접수 번호
			stmt.setString(2, paymentCategory); // 환자가 이용한 서비스(수술, 처방, 진료, 검사, 입원)
			
			updateRow = stmt.executeUpdate();
			
			conn.close();
			return updateRow;
		}
	
	/*
	 * 메소드		: #incomeLast(String year, String month)
	 * 페이지		: income.jsp
	 * 시작 날짜	: 2024-05-17
	 * 담당자		: 박혜아
	*/
	public static HashMap<String, Integer> incomeLast(String year, String month) throws Exception{
		HashMap<String, Integer> map = new HashMap<>();
		
		// 값 디버깅
		//System.out.println("PaymentDao#income() year--> "+year);
		//System.out.println("PaymentDao#income() month--> "+month);
		
		//DB연결
		Connection conn = DBHelper.getConnection();
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		/* SELECT(조회화면에서 보여줄 것)
		 * pay : 해당하는 년도/달의 각 매출액 및 총 매출액 (null일 경우 0으로 치환 후 계산)
		*/
		String sql = "SELECT pm.regi_no regiNo, pet.pet_name petName, pm.payment_state paymentState, pm.create_date createDate,"
				+ " IFNULL(sum(DISTINCT cn.clinic_cost), 0) clinicSum,"
				+ " IFNULL(sum(DISTINCT ek.examination_cost), 0) examinationSum,"
				+ " IFNULL(sum(DISTINCT sk.surgery_cost), 0) surgerySum,"
				+ " IFNULL(sum(DISTINCT hr.cost), 0) hospitalSum,"
				+ " IFNULL(sum(DISTINCT md.medicine_cost), 0) medicineSum"
				+ " FROM payment pm"
				+ " INNER JOIN registration regi ON pm.regi_no = regi.regi_no"
				+ " INNER JOIN pet pet ON regi.pet_no = pet.pet_no"
				+ " INNER JOIN customer c ON pet.customer_no = c.customer_no"
				+ " LEFT JOIN clinic cn ON pm.regi_no = cn.regi_no"
				+ " LEFT JOIN examination ex ON pm.regi_no = ex.regi_no"
				+ " LEFT JOIN examination_kind ek ON ex.examination_kind = ek.examination_kind"
				+ " LEFT JOIN surgery sg ON pm.regi_no = sg.regi_no"
				+ " LEFT JOIN surgery_kind sk ON sg.surgery_kind = sk.surgery_kind"
				+ " LEFT JOIN hospitalization hp ON pm.regi_no = hp.regi_no"
				+ " LEFT JOIN hospital_room hr ON hp.room_name = hr.room_name"
				+ " LEFT JOIN prescription ps ON pm.regi_no = ps.regi_no"
				+ " LEFT JOIN medicine md ON ps.medicine_no = md.medicine_no"
				+ " WHERE pm.payment_state LIKE '완납'"
				+ "	AND DATE_FORMAT(pm.create_date, '%Y-%m') = ?"
				+ "	GROUP BY pm.regi_no, pm.payment_state, pm.create_date"
				+ "	ORDER BY pm.create_date DESC";
		
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, year + "-" + month);
		//stmt.setString(1, year);
		//stmt.setString(2, month);
		System.out.println("PaymentDao#income() stmt--> "+stmt);
		
		rs = stmt.executeQuery();
		
		int clinicSumMonth = 0;
		int examinationSumMonth = 0;
		int surgerySumMonth = 0;
		int hospitalSumMonth = 0;
		int medicineSumMonth = 0;
		int totalMonth = 0;
		
		while(rs.next()) {
			clinicSumMonth = clinicSumMonth + rs.getInt("clinicSum");
			examinationSumMonth = examinationSumMonth + rs.getInt("examinationSum");
			surgerySumMonth = surgerySumMonth + rs.getInt("surgerySum");
			hospitalSumMonth = hospitalSumMonth + rs.getInt("hospitalSum");
			medicineSumMonth = medicineSumMonth + rs.getInt("medicineSum");
		}
		
		totalMonth = clinicSumMonth + examinationSumMonth + surgerySumMonth + hospitalSumMonth + medicineSumMonth;
		
		System.out.println(clinicSumMonth + " <--총매출확인 clinicSumMonth");
		System.out.println(examinationSumMonth + " <--총매출확인 examinationSumMonth");
		System.out.println(surgerySumMonth + " <--총매출확인 surgerySumMonth");
		System.out.println(hospitalSumMonth + " <--총매출확인 hospitalSumMonth");
		System.out.println(medicineSumMonth + " <--총매출확인 medicineSumMonth");
		System.out.println(totalMonth + " <--총매출확인 totalMonth");
		
		map = new HashMap<>();
		map.put("clinicSum", clinicSumMonth);
		map.put("examinationSum", examinationSumMonth);
		map.put("surgerySum", surgerySumMonth);
		map.put("hospitalSum", hospitalSumMonth);
		map.put("medicineSum", medicineSumMonth);
		map.put("monthSum", totalMonth);
		
		
		conn.close();
		return map;
	}
	
	
	
	
	
	
	
	
	
	
	
	
}
