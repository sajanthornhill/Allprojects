<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<%
	try {
		ApplicationDB db = new ApplicationDB();	
		Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BuyElectronics", "root", "Rootuser!1");	
		Statement st = con.createStatement();
		//Get parameters from Users.jsp
		String userid = request.getParameter("userID");
		String pwd = request.getParameter("password");
		ResultSet rs;
		rs = st.executeQuery("SELECT * FROM users where username='" + userid + "'");
		//checks if username is already taken
		if (rs.next()) {
			out.println("This username is taken. <a href='Users.jsp'>Try again.</a>");
		//make user account
		} else {
			String sql = "INSERT INTO users(account_id, username, user_password, isAdmin, isCusRes)"
				+ "VALUES (?, ?, ?, ?, ?)";
			PreparedStatement ps = con.prepareStatement(sql);
			
			ResultSet rs2 = st.executeQuery("SELECT MAX(account_id) AS account_id FROM users");
			rs2.next();
			int account_id = rs2.getInt("account_id") + 1;
			ps.setInt(1, account_id);
			ps.setString(2, userid);
			ps.setString(3, pwd);
			ps.setBoolean(4, false);
			ps.setBoolean(5, false);
			ps.executeUpdate();
			con.close();
			response.sendRedirect("registrationsuccessful.jsp"); 
		}
		
	} catch (Exception ex) {
		response.sendRedirect("registrationerror.jsp"); 
	}
	
%>
</body>
</html>