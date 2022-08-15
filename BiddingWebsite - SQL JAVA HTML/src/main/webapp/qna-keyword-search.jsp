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
    Statement st2 = con.createStatement();   
    Statement st3 = con.createStatement();   
    
    String keyword = request.getParameter("keyword");
    
    ResultSet rs, rs2, rs3;
    rs = st.executeQuery("select * from qna where question like '%"+keyword+"%' or answer like '%"+keyword+"%'");
    
    if (rs.next()) {
        %>
         <table border="2" cellpadding="5">
             <tr>
                 <th>Question Number</th>
                <th>Question</th>
                 <th>Answer</th>
                 <th>Posted by</th>
                <th>Answered by</th>
                 
             </tr>
             <%
             rs.previous();
             while(rs.next()){
                  int user_id = rs.getInt("user_id");
                  int cusrep_id = rs.getInt("cusrep_id");
                  String username = "";
                  String cusrep = "";
    
                  rs2 = st2.executeQuery("Select * from users where account_id = "+user_id);
                  rs3 = st3.executeQuery("Select * from users where account_id = "+cusrep_id);
                  if(rs2.next())
                    username = rs2.getString("username");
                  if(rs3.next())
                    cusrep = rs3.getString("username");
                  else 
                    cusrep = "";
    %>
                 <tr>
                    <td><%=rs.getInt("q_id")%></td>
                    <td><%=rs.getString("question")%></td>
                    <td><%=rs.getString("answer")%></td>
                    <td><%=username%></td>
                    <td><%=cusrep%></td>
                 </tr>
             <%}%>
        </table>
        
    
        <br><br>
     <%
    }else{
          out.println("No QnA found.");
      }   
    con.close();
    out.println("<a href='qna-show.jsp'>Go Back</a>");
}
%>