package atti;


import java.sql.*;
import java.util.*;

public class CustomerDao {
	/*
	 * 메소드: CustomerDao#customerUpdate()
	 * 페이지: customerUpdateAction.jsp
	 * 시작 날짜: 2024-05-13
	 * 담당자: 김지훈
	*/
	
	public static int customerUpdate(int customerNo, String customerTel, String customerAddress) throws Exception {
		System.out.println("CustomerDao#customerUpdate customerNo: " + customerNo);
		System.out.println("CustomerDao#customerUpdate customerTel:" + customerTel);
		System.out.println("CustomerDao#customerUpdate customerAddress:" + customerAddress);
		
		int updateRow = 0;
		
		Connection conn = DBHelper.getConnection();
		
		String sql = "UPDATE customer SET customer_tel = ?, customer_address = ?"
				+ "WHERE customer_no = ?"; 
		
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, customerTel);
		stmt.setString(2, customerAddress);
		stmt.setInt(3, customerNo);
		
		System.out.println("CustomerDao#customerUpdate: " + stmt);
		
		updateRow = stmt.executeUpdate();
		
		conn.close();
		return updateRow;
	}
	
	
	/*
	 * 메소드: CustomerDao#searchAll()
	 * 페이지: searchList.jsp
	 * 시작 날짜: 2024-05-12
	 * 담당자: 김지훈
	*/
	public static ArrayList<HashMap<String, Object>> searchAll(String searchWord, int startRow, int rowPerPage) throws Exception {
		System.out.println("CustomerDao#customerUpdate searchAll: " + searchWord);
		System.out.println("CustomerDao#customerUpdate searchAll" + startRow);
		System.out.println("CustomerDao#customerUpdate searchAll" + rowPerPage);
		
		ArrayList<HashMap<String, Object>> searchAll = new ArrayList<HashMap<String, Object>>();
		
		Connection conn = DBHelper.getConnection();
		
		String sql = null;
		if(searchWord != null) {
			sql = "SELECT c.customer_no customerNo, c.customer_name customerName,"
					+ " c.customer_tel customerTel, p.pet_no petNo, p.pet_name petName, p.create_date createDate"
					+ " FROM customer c"
					+ " INNER JOIN pet p"
					+ " ON c.customer_no = p.customer_no"
					+ " WHERE c.customer_name LIKE ? OR c.customer_tel LIKE ? OR p.pet_name LIKE ?"
					+ " ORDER BY p.create_date DESC"
					+ " LIMIT ?, ?";
			
		} else {
			sql = "SELECT c.customer_no customerNo, c.customer_name customerName,"
					+ " c.customer_tel customerTel, p.pet_no petNo, p.pet_name petName, p.create_date createDate"
					+ " FROM customer c"
					+ " INNER JOIN pet p"
					+ " ON c.customer_no = p.customer_no"
					+ " ORDER BY p.create_date DESC"
					+ " LIMIT ?, ?";
		}
		
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		System.out.println("CustomerDao#customerUpdate: " + stmt);
		
		if(searchWord != null) {
			stmt.setString(1, "%" + searchWord + "%");
			stmt.setString(2, "%" + searchWord + "%");
			stmt.setString(3, "%" + searchWord + "%");
			stmt.setInt(4, startRow);
			stmt.setInt(5, rowPerPage);
		} else {
			stmt.setInt(1, startRow);
			stmt.setInt(2, rowPerPage);	
		}
		ResultSet rs = stmt.executeQuery();
		
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			m.put("customerNo", rs.getInt("customerNo"));
			m.put("customerName", rs.getString("customerName"));
			m.put("customerTel", rs.getString("customerTel"));
			m.put("petNo", rs.getInt("petNo"));
			m.put("petName", rs.getString("petName"));
			m.put("createDate", rs.getString("createDate"));
			searchAll.add(m);
		}
		
		conn.close();
		return searchAll;
	}
	
	
	/*
	 * 메소드: CustomerDao#customerSearch()
	 * 페이지: searchList.jsp
	 * 시작 날짜: 2024-05-11
	 * 담당자: 김지훈
	*/
	
	public static ArrayList<HashMap<String, Object>> customerSearch(String searchWord, int startRow, int rowPerPage) throws Exception {
		
		System.out.println("CustomerDao#customerUpdate customerSearch searchWord: " + searchWord);
		System.out.println("CustomerDao#customerUpdate customerSearch startRow: " + startRow);
		System.out.println("CustomerDao#customerUpdate customerSearch rowPerPage: " + rowPerPage);
		
		ArrayList<HashMap<String, Object>> customerSearch = new ArrayList<HashMap<String, Object>>();
		
		Connection conn = DBHelper.getConnection();
		
		String sql = null;
		
		sql = "SELECT c.customer_no customerNo, c.customer_name customerName,"
			+ " c.customer_tel customerTel,"
			+ " COUNT(p.pet_no) petCnt, c.create_date createDate"
			+ " FROM customer c "
			+ " LEFT JOIN pet p"
			+ " ON c.customer_no = p.customer_no"
			+ " WHERE c.customer_name LIKE ? OR c.customer_tel LIKE ?"
			+ " GROUP BY c.customer_no, c.customer_name, c.customer_tel"
			+ " ORDER BY c.create_date DESC";
		
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		System.out.println("CustomerDao#customerUpdate customerSearch: " + stmt);
		
		if(searchWord != null) {
			stmt.setString(1, "%" + searchWord + "%");
			stmt.setString(2, "%" + searchWord + "%");
			stmt.setInt(3, startRow);
			stmt.setInt(4, rowPerPage);
		} else {
			stmt.setInt(1, startRow);
			stmt.setInt(2, rowPerPage);
		}
		
		ResultSet rs = stmt.executeQuery();
		
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			m.put("customerNo", rs.getInt("customerNo"));
			m.put("customerName", rs.getString("customerName"));
			m.put("customerTel", rs.getString("customerTel"));
			m.put("petCnt", rs.getInt("petCnt"));
			m.put("createDate", rs.getString("createDate"));
			customerSearch.add(m);
		}
		conn.close();
		return customerSearch;
		
	}
	
	/*
	 * 메소드: CustomerDao#customerDetail()
	 * 페이지: customerDetail.jsp
	 * 시작 날짜: 2024-05-10
	 * 담당자: 김지훈
	*/	
	
	public static ArrayList<HashMap<String, Object>>customerDetail(int customerNo) throws Exception {
		ArrayList<HashMap<String, Object>> customerDetail = new ArrayList<HashMap<String, Object>>();
		
		System.out.println("CustomerDao#customerDetail customerNo: " + customerNo);
		
		Connection conn = DBHelper.getConnection();
		
		String sql = "SELECT *"
				+ " FROM customer"
				+ " WHERE customer_no =?";
		
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, customerNo);
		
		System.out.println("CustomerDao#customerDetail: " + stmt);
		
		ResultSet rs = stmt.executeQuery();
		
		while(rs.next()) {
			HashMap<String, Object> m = new HashMap<String, Object>();
			m.put("customerNo", rs.getInt("customer_no"));
			m.put("customerName", rs.getString("customer_name"));
			m.put("customerTel", rs.getString("customer_tel"));
			m.put("customerAddress", rs.getString("customer_address"));
			customerDetail.add(m);
		}
		conn.close();
		
		return customerDetail;
	}
	
	
	/*
	 * 메소드: CustomerDao#customerRegistration()
	 * 페이지: customerRegiAction.jsp
	 * 시작 날짜: 2024-05-10
	 * 담당자: 김지훈
	*/
	public static int customerRegistration(String customerName, String customerTel, String customerAddress) throws Exception {
		
		// customerRegiForm -> customerRegiAction 매개 변수값 확인
		System.out.println("CustomerDao#customerRegistration customerName: " + customerName);
		System.out.println("CustomerDao#customerRegistration customerTel: " + customerTel);
		System.out.println("CustomerDao#customerRegistration customerAddress: " + customerAddress);
		
		
		int customerNo = 0; 
		int row = 0;

		// DB 연결 
		Connection conn = DBHelper.getConnection();
		
		String sql = "INSERT INTO customer(customer_name, customer_tel, customer_address, create_date, update_date)"
				+ " VALUES(?, ?, ?, NOW(), NOW())";
		
		PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
																// DB 내에서 customerNo를 생성과 동시에 추출
		stmt.setString(1, customerName);
		stmt.setString(2, customerTel);
		stmt.setString(3, customerAddress);
		
		System.out.println("CustomerDao#customerRegistration: " + stmt);
		
		
		row = stmt.executeUpdate();
		
		
		if(row > 0) {
			ResultSet generatedKeys = stmt.getGeneratedKeys();
			if(generatedKeys.next()) {
				customerNo = generatedKeys.getInt(1); // DB 내 첫 번째 컬럼을 추출
			}
			generatedKeys.close(); // 실행 후 키 리소스 해제
		}
		
		conn.close(); // 자원 반납
		
		return customerNo; // customerNo를 반환
	}
}