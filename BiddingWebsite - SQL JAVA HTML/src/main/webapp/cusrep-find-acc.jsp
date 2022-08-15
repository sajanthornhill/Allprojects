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
String item = request.getParameter("auctionid");   
    
ResultSet rs;
rs = st.executeQuery("Select * from users");
if (rs.next() == true) {
    session.setAttribute("itemName", item); //delete?
    //response.sendRedirect("HelloWorld.jsp");
   // rs.first();
    %>
     <table border="2" cellpadding="5">
         <tr>
             <th>User ID</th>
            <th>Username</th>
            <th>Password</th>
             <th>Is Admin</th>
             <th>Is Customer Rep</th>
             
         </tr>
         <%
         rs.previous();
         while(rs.next()){%>
             <tr>
                 <td><%=rs.getInt("account_id")%></td>
                <td><%=rs.getString("username")%></td>
                <td><%=rs.getString("user_password")%></td>
                 <td><%=rs.getBoolean("isAdmin")%></td>
                 <td><%=rs.getBoolean("isCusRes")%></td>			
             </tr>
         <%}%>
    </table>
    

    <br><br>

    
    <form action="cusrep-edit-acc-info.jsp" method="post">
        Username <input type="text" name="un" required><br>
        Password <input type="text" name="pw" required><br>
        New Username <input type="text" name="newun"><br>
        New Password <input type="text" name="newpw"><br>
        <label for="do-this">Action to perform</label>
        <select name="perform" required>
        <option value="del-acc">Delete Account</option>
        <option value="chn-pw">Change Password</option>
        <option value="chn-usn">Change Username</option>
        </select>
        <input type="submit">
    </form>

    
 <%
}else {
    out.println("Invalid Search!");
}
con.close();
%>
<a href="cusrep-home.jsp">Go Back</a>
<%
}
%>