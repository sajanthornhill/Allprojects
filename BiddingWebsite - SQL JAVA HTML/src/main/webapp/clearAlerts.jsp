<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<%

ApplicationDB db = new ApplicationDB();	
Class.forName("com.mysql.jdbc.Driver");
Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BuyElectronics", "root", "Rootuser!1");	
Statement st = con.createStatement();





String da = "DELETE FROM alert WHERE account_id = ?";

 PreparedStatement ps = con.prepareStatement(da);
 ps.setInt(1, (Integer)session.getAttribute("account_num"));
ps.executeUpdate();
 %>
Alerts Clear
   <a href='welcome.jsp'>Go Back</a>
   
			     
			     
			    