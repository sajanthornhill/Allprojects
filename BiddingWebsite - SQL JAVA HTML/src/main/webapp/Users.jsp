<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>eBay</title>
	</head>

	<body>
		<br>
		<form method="post" action="register-account-login.jsp">
		Register here
			<table>
				<tr>    
					<td>Username:</td><td><input type="text" name="userID"></td>
				</tr>
				<tr>
					<td>Password:</td><td><input type="text" name="password"></td>
				</tr>
				<tr>
       				<td>Confirm Password:</td><td><input type="text" name="password2"></td>
       			</tr>
			</table>
			<input type="submit" value="Create Account">
		</form>
		<br>
		<br>
		<form method="post" action="check-account-login.jsp">
		Sign in here
			<table>
				<tr>
					<td>Username:</td><td><input type="text" name="userID"> </td>
				</tr>
				<tr>
					<td>Password:</td><td><input type="text" name="password"></td>
				</tr>
			</table>
			<input type="submit" value="Sign in">
		</form>
		<br>
		
</body> 
</html>