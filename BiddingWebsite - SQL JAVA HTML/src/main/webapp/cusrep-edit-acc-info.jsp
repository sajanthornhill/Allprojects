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
<%} else {
%>
Welcome <%=session.getAttribute("userID")%> <br><br>

<style> .footer {
      position: fixed;
      left: 0;
      bottom: 0;
      width: 100%;
      font-size: 30;
      background-color: rgb(211, 208, 208);
      color: white;
      text-align: center;
    } </style>
    
    <div class="footer"> 
      <p><a href='welcome.jsp'>Home</a><br><a href='logout.jsp'>Log out</a></p>
    </div>
<%
    ApplicationDB db = new ApplicationDB();	
    Class.forName("com.mysql.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BuyElectronics", "root", "Rootuser!1");	
    Statement st = con.createStatement();   
    
    String username = request.getParameter("un");  
    String password = request.getParameter("pw");  
    String newUsername = request.getParameter("newun");  
    String newPassword = request.getParameter("newpw");  
    
    
    ResultSet rs;
    rs = st.executeQuery("select * from users where username='" + username + "' and user_password = '"+password+"'");
    if (rs.next()) {
        switch(request.getParameter("perform")){
            case "del-acc": String sql = "delete from users where username = ? and user_password = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            ps.executeUpdate();
            out.println("Success!<a href='cusrep-home.jsp'>Go Back</a>");
            break;
            case "chn-pw": String sql2 = "update users set user_password = ? where username = ? and user_password = ?";
            PreparedStatement ps2 = con.prepareStatement(sql2);
            ps2.setString(1, newPassword);
            ps2.setString(2, username);
            ps2.setString(3, password);
            ps2.executeUpdate();
            out.println("Success!<a href='cusrep-home.jsp'>Go Back</a>");
            break;
            case "chn-usn":String sql3 = "update users set username = ? where username = ? and user_password = ?";
            PreparedStatement ps3 = con.prepareStatement(sql3);
            ps3.setString(1, newUsername);
            ps3.setString(2, username);
            ps3.setString(3, password);
            ps3.executeUpdate();
            out.println("Success!<a href='cusrep-home.jsp'>Go Back</a>");
            break;
            default: out.println("Invalid request<a href='cusrep-home.jsp'>try again</a>");
        }	
                
    } else {
        out.println("Invalid username or password <a href='cusrep-home.jsp'>try again</a>");
    }
    
    con.close();
%>
  
<%
}
%>