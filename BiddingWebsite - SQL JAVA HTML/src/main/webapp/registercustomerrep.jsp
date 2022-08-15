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
		Connection con = db.getConnection();

		//Create a SQL statement
		Statement stmt = con.createStatement();

		//Get parameters from the HTML form at the HelloWorld.jsp
		String newEmail = request.getParameter("userID");
		String newPassword = request.getParameter("password");
		String password2 = request.getParameter("password2");
		if(!newPassword.equals(password2)){
			response.sendRedirect("registrationerror.jsp");
		}
		String accounttype = "";
		if (newEmail.equals("sajansaylor@gmail.com")){
			accounttype = "admin";
		}
		else{
			accounttype = "enduser";
		}
		

		//Make an insert statement for the Sells table:
		String insert = "INSERT INTO users(userID, password, accountType)"
				+ "VALUES (?, ?, ?)";
		//Create a Prepared SQL statement allowing you to introduce the parameters of the query
		PreparedStatement ps = con.prepareStatement(insert);
		
		ps.setString(1, newEmail);
		ps.setString(2, newPassword);
		ps.setString(3, accounttype);
		//Run the query against the DB
		ps.executeUpdate();
		//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
		con.close();          
		response.sendRedirect("registrationsuccessful.jsp"); 
		//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itsel 
		
	} catch (Exception ex) {
		response.sendRedirect("registrationerror.jsp"); 
	}
	
%>
</body>
</html>