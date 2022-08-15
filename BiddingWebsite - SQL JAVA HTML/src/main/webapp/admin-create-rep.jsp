<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%
    if ((session.getAttribute("userID") == null)) {
%>
    You are not logged in!
    <script type="text/javascript">
        setTimeout(()=> { window.location.href="Users.jsp"; }, 1000);  
    </script>
<%}%> <br><br>

<%
    ApplicationDB db = new ApplicationDB();	
    Class.forName("com.mysql.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BuyElectronics", "root", "Rootuser!1");	
    Statement st = con.createStatement();
    
    //Gets parameters from Admin.jsp
    String userid = request.getParameter("username");   
    String pwd = request.getParameter("password");
    
    ResultSet rs;
    rs = st.executeQuery("SELECT * FROM users where username='" + userid + "'");
    //checks if username is already taken
    if (rs.next()) {
        session.setAttribute("acctmsg","");
        out.println("This username is taken. <a href='admin.jsp'>Try again.</a>");
    //make customer rep account
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
        ps.setBoolean(5, true);
        ps.executeUpdate();
        con.close();
        session.setAttribute("acctmsg","Account successfully created");
        response.sendRedirect("admin.jsp");
    }
    
%>