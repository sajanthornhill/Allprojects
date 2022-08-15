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
Welcome <%=session.getAttribute("userID")%> 


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
      <p><a href='admin.jsp'>Home</a><br><a href='logout.jsp'>Log out</a></p>
    </div>

<br><br>

Generate sales report
<form action = 'admin-sales-report.jsp', method="POST">
       <input type="submit" value="Generate"/>
</form>

Create a new customer representative
    <br>
        <form action = 'admin-create-rep.jsp', method="post">
        <table>
        <tr>
        <td>Username</td><td><input type="text" name="username"></td>
        </tr>
        <tr>
        <td>Password</td><td><input type="text" name="password"></td>
        </tr>
        </table>
        <input type="submit" value="Create Account">
        </form>
        ${acctmsg}
    <br>
    
    
<%
}
%>