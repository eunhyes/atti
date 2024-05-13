package atti;

import java.sql.*;
import java.util.*;

public class ExaminationDao {

	/*
	 * 메소드 : ExaminationDao#examinationList() 
	 * 페이지 : examinationList.jsp
	 * 시작 날짜 : 2024-05-10
	 * 담당자 : 한은혜 
	 */
	public static ArrayList<HashMap<String, Object>> examinationList(String searchDate) throws Exception{
		
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
		// DB연결
		Connection conn = DBHelper.getConnection();
		
		// 검사 정보 출력 쿼리  
		// 검사 조회에서 pet_kind, pet_name 보여주기 + 검사 날짜 내림차순(최신순)
		String sql = "SELECT pet_kind petKind, pet_name petName, examination_no examinationNo, examination_kind examinationKind, examination_content examinationContent, examination_date examinationDate"
				+ " FROM examination e"
				+ " LEFT JOIN registration r"
				+ " ON e.regi_no = r.regi_no"
				+ " LEFT JOIN pet p"
				+ " ON r.pet_no = p.pet_no"
				+ " WHERE DATE(examination_date) = ?"
				+ " ORDER BY examination_date DESC";
				
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, searchDate);
		System.out.println(stmt + " ====== examinationList stmt");
		
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			HashMap<String, Object> e = new HashMap<String, Object>();
			e.put("petKind", rs.getString("petKind"));
			e.put("petName", rs.getString("petName"));
			e.put("examinationNo", rs.getInt("examinationNo"));
			e.put("examinationKind", rs.getString("examinationKind"));
			e.put("examinationContent", rs.getString("examinationContent"));
			e.put("examinationDate", rs.getString("examinationDate"));
			list.add(e);
			
		}
		
		conn.close();
		return list;
		
	}
	
	/*
	 * 메소드 : ExaminationDao#examinationDetail() 
	 * 페이지 : examinationDetail.jsp
	 * 시작 날짜 : 2024-05-10
	 * 담당자 : 한은혜 
	 */
	public static ArrayList<HashMap<String, Object>> examinationDetail() throws Exception{
		
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
		// DB연결
		Connection conn = DBHelper.getConnection();
		
		// 검사 상세보기
		// 검사 조회에서 photo_no, photo_name 추가 + 검사 사진이 없는 것은 출력 X
		String sql = "SELECT"
				+ " photo_no photoNo, photo_name photoName, " // 검사 - 사진 번호, 사진 이름
				+ " pet_kind petKind, pet_name petName, " // 반려동물 - 동물 종류, 반려동물 이름 
				+ " e.examination_no examinationNo, examination_kind examinationKind, examination_content examinationContent, examination_date examinationDate"
				+ " FROM examination e"
				+ " LEFT JOIN registration r"
				+ " ON e.regi_no = r.regi_no"
				+ " LEFT JOIN pet p"
				+ " ON r.pet_no = p.pet_no"
				+ " LEFT JOIN examination_photo ep "
				+ " ON e.examination_no = ep.examination_no "
				+ " WHERE e.examination_no = ep.examination_no "
				+ " AND ep.photo_no IS NOT NULL";
	
		PreparedStatement stmt = conn.prepareStatement(sql);
		System.out.println(stmt + " ====== examinationDetail stmt");
		
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			HashMap<String, Object> d = new HashMap<String, Object>();
			d.put("photoNo", rs.getInt("photoNo"));
			d.put("photoName", rs.getString("photoName"));
			d.put("petKind", rs.getString("petKind"));
			d.put("petName", rs.getString("petName"));
			d.put("examinationNo", rs.getInt("examinationNo"));
			d.put("examinationKind", rs.getString("examinationKind"));
			d.put("examinationContent", rs.getString("examinationContent"));
			d.put("examinationDate", rs.getString("examinationDate"));
		
		}
		
		conn.close();
		return list;
	}
	//TODO : examinationDetail.jsp 에서 examinatioNo을 못 받음
}