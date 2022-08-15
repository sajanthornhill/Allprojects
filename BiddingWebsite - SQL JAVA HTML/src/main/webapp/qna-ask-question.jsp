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

<br><br>

<%
    ApplicationDB db = new ApplicationDB();	
    Class.forName("com.mysql.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BuyElectronics", "root", "Rootuser!1");	
    Statement st = con.createStatement();   
    
    String question = request.getParameter("question");
    
    ResultSet rs, rs2;
    
    if (question!= null) {
    	String sql = "insert into qna values (? , ?, NULL, ?, NULL)";
        PreparedStatement ps = con.prepareStatement(sql);
        
        int q_id = 1;
        rs = st.executeQuery("Select max(q_id) from qna");
        if(rs.next())
            q_id = rs.getInt("max(q_id)") + 1;
        String username = session.getAttribute("userID").toString();
        int user_id = 0;
        rs2 = st.executeQuery("Select * from users where username = '"+username+"'");
        if(rs2.next())
            user_id = rs2.getInt("account_id");
        ps.setInt(1, q_id);
 		    ps.setString(2, question);
        ps.setInt(3, user_id);
        ps.executeUpdate();
        out.println("Success!");
            
    }else{
          out.println("No Question Entered.");
      }   
    con.close();
    
    out.println("<a href='qna-show.jsp'>Go Back</a>");
}
%>