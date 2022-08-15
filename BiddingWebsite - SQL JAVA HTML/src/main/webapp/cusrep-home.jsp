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

    Look at questions (Press Search to see all entries)
    <form action = 'cusrep-find-qna.jsp', method="POST">
      Enter Question ID <input type="text" name="qid"/> <br/>
      <input type="submit" value="Search by Keyword"/>
    </form>

    Edit an auction or bid (Press Search to see all entries)
    <form action = 'cusrep-find-bid.jsp', method="POST">
      Enter the auction id: <input type="text" name="auctionid"/> <br/>
      <input type="submit" value="Search by Keyword"/>
    </form>

    Edit an account
      <form method="get" action="cusrep-find-acc.jsp">
      <button type="submit">Continue</button>
    </form>

<%
  }
%>