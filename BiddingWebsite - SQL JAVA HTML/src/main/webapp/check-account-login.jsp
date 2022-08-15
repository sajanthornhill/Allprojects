<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<%
    try{
	ApplicationDB db = new ApplicationDB();	
    Class.forName("com.mysql.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BuyElectronics", "root", "Rootuser!1");	
    Statement st = con.createStatement();
    
    String userid = request.getParameter("userID");   
    String pwd = request.getParameter("password");
    
    //out.println("userID: "+userid+"\tpassword: "+pwd);
    ResultSet rs;
    rs = st.executeQuery("select * from users where username='" + userid + "' and user_password='" + pwd + "'");
    if (rs.next()) {
        session.setAttribute("userID", userid);
        session.setAttribute("account_num", rs.getInt("account_id"));// the username will be stored in the session
        boolean isAdmin = rs.getBoolean("isAdmin");
        boolean isCusRes = rs.getBoolean("isCusRes");
        if(!isAdmin && !isCusRes) response.sendRedirect("welcome.jsp");
        else if(isAdmin){
            session.setAttribute("acctmsg","");
            response.sendRedirect("admin.jsp");
        } 
        else response.sendRedirect("cusrep-home.jsp");
        out.println("<a href='logout.jsp'>Log out</a>");
    } else {
        out.println("Invalid password. <a href='Users.jsp'>try again</a>");
    }
    
    con.close();
} catch (Exception ex) {
    out.print(ex);
    out.print("login failed :(");
}
%>