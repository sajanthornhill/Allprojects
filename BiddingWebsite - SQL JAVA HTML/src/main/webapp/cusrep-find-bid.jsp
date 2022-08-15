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
	Statement st2 = con.createStatement();
	Statement st3 = con.createStatement();
	Statement st4 = con.createStatement();
    String item = request.getParameter("auctionid");   
        
	
    ResultSet rs, rs2, rs3, rs4;
	String item_name = "", buyer_name ="", seller_name="";
    rs = st.executeQuery("Select * from viewHistory where auction_id like '%" + item + "%'");
    if (rs.next() == true) {
        session.setAttribute("itemName", item); //delete?
        //response.sendRedirect("HelloWorld.jsp");
       // rs.first();
        %>
 		<table border="2" cellpadding="5">
 			<tr>
 				<th>Auction ID</th>
				<th>Bid ID</th>
 				<th>Item ID</th>
				<th>Item Name</th>
 				<th>Current Price</th>
				<th>Seller ID</th>
				<th>Seller Name</th>
				<th>Buyer ID</th>
				<th>Buyer Name</th>
 				
 			</tr>
 			<%
 			rs.previous();
 			while(rs.next()){
				rs2 = st2.executeQuery("Select * from electronic_item where item_id = "+rs.getInt("item_id"));
				rs3 = st3.executeQuery("Select * from users where account_id = "+rs.getInt("seller_id"));
				rs4 = st4.executeQuery("Select * from users where account_id = "+rs.getInt("user_account_id"));
				if(rs2.next())
				  item_name = rs2.getString("item_type");
				if(rs3.next())
				  seller_name = rs3.getString("username");
				if(rs4.next())
				  buyer_name = rs4.getString("username");
				 
			%>
 				<tr>
 					<td><%=rs.getInt("auction_id")%></td>
					<td><%=rs.getInt("history_id")%></td>
 					<td><%=rs.getInt("item_id")%></td>
					<td><%=item_name%></td>
 					<td><%=rs.getFloat("price")%></td>
					<td><%=rs.getInt("seller_id")%></td>
					<td><%=seller_name%></td>
 					<td><%=rs.getInt("user_account_id")%></td>	
					<td><%=buyer_name%></td>		
 				</tr>
 			<%}%>
		</table>
		

		<br><br>

		Delete Bid
 		<form action = 'cusrep-delete-bid.jsp', method="post">
	    	Enter Bid ID of bid to delete </td><td><input type="text" name="bidid" required><br>
	    	Enter Seller ID </td><td><input type="text" name="sellerid" required><br>
	    	Enter Buyer ID </td><td><input type="text" name="buyerid"><br>
        <input type="submit" value="Delete Bid">
    	</form><br>

		Delete Item/Auction
		<form action = 'cusrep-delete-auction.jsp', method="post">
			Enter Item ID</td><td><input type="text" name="id" required><br>
			<input type="submit" value="Delete Item">
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