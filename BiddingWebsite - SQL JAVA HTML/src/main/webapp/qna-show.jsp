<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%
    if (session.getAttribute("userID") == null) {
%>
    You are not logged in!
    <script type="text/javascript">
      setTimeout(()=> { window.location.href="Users.jsp"; }, 1000);  
    </script>
<%
}else {
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
Statement st2 = con.createStatement();    
Statement st3 = con.createStatement();    
ResultSet rs, rs2, rs3;
rs = st.executeQuery("Select * from qna");
if (rs.next() == true) {
    %>
     <table border="2" cellpadding="5">
         <tr>
             <th>Question Number</th>
            <th>Question</th>
             <th>Answer</th>
             <th>Posted by </th>
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

    Ask A Question
     <form action = 'qna-ask-question.jsp', method="post">
        Question </td><td><input type="text" name="question" required><br>
    <input type="submit" value="Ask">
    </form><br>
    
    Search using a keyword     
    <form action = 'qna-keyword-search.jsp', method="post">
        Keyword </td><td><input type="text" name="keyword" required><br>
    <input type="submit" value="Ask">
    </form><br>

 <%
}else {
    out.println("Invalid Search.");
}
con.close();
%>
<a href='welcome.jsp'>Go Back</a><%
}
%>