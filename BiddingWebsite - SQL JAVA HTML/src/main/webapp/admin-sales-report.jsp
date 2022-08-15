<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<%
    ApplicationDB db = new ApplicationDB();	
    Class.forName("com.mysql.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BuyElectronics", "root", "Rootuser!1");	
    
    Statement st1 = con.createStatement();
    String sql1 = "select sum(current_price) as total from auction where auction_active = 'false' and sold_to_id is not null";
    ResultSet total_earnings = st1.executeQuery(sql1);
    Statement st2 = con.createStatement();
    String sql2 = "select e.model_Number as item, sum(a.current_price) as total from electronic_item e join auction a using (item_id) where a.auction_active = 'false' and a.sold_to_id is not null group by e.model_Number";
    ResultSet earnings_item = st2.executeQuery(sql2);
    Statement st3 = con.createStatement();
    String sql3 = "select e.item_type as item_type, sum(a.current_price) as total from auction a join electronic_item e using (item_id) where auction_active = 'false' and sold_to_id is not null group by e.item_type";
    ResultSet earnings_itemtype = st3.executeQuery(sql3);
    Statement st4 = con.createStatement();
    String sql4 = "select u.username, sum(a.current_price) as total from auction a, users u where u.account_id = a.seller_id and auction_active = 'false' and sold_to_id is not null group by u.username";
    ResultSet earnings_user = st4.executeQuery(sql4);
    Statement st5 = con.createStatement();
    String sql5 = "select e.model_Number as item, count(*) as num_sold, sum(a.current_price) as total from electronic_item e join auction a using (item_id) where a.auction_active = 'false' and a.sold_to_id is not null group by e.model_Number order by total desc limit 3";
    ResultSet best_items = st5.executeQuery(sql5);
    Statement st6 = con.createStatement();
    String sql6 = "select u.username, count(*) as num_purchases, sum(a.current_price) as total from auction a, users u where u.account_id = a.buyer_id and auction_active = 'false' and sold_to_id is not null group by u.username order by total desc limit 3";
    ResultSet best_buyers = st6.executeQuery(sql6);
    try{
        total_earnings.next();
        %>
		<b>Total Earnings</b>
 		<table border="1">
                <td><%=total_earnings.getFloat("total")%></td>	
            </tr>
 		</table> 

        <hr size="3">
        
		<b>Earnings Per Item</b>
 		<table border="1">
 			<tr>
 				<td>Item</td><td>Earnings</td>
 			</tr>
 				<%
 				while(earnings_item.next()){%>
 					<tr>
 						<td><%=earnings_item.getString("item")%></td>
 						<td><%=earnings_item.getFloat("total")%></td>
 					</tr>
 				<%}%>
 		</table>

         <hr size="3">

        <b>Earnings Per Item Type</b>
 		<table border=1>
 			<tr>
 				<td>Item Type</td><td>Earnings</td>
 			</tr>
 				<%
 				while(earnings_itemtype.next()){%>
 					<tr>
 						<td><%=earnings_itemtype.getString("item_type")%></td>
 						<td><%=earnings_itemtype.getFloat("total")%></td>
 					</tr>
 				<%}%>
 		</table>       

         <hr size="3">

        <b>Earnings Per End User</b>
 		<table border="1">
 			<tr>
 				<td>Username</td><td>Earnings</td>
 			</tr>
 				<%
 				while(earnings_user.next()){%>
 					<tr>
 						<td><%=earnings_user.getString("username")%></td>
 						<td><%=earnings_user.getFloat("total")%></td>
 					</tr>
 				<%}%>
 		</table>   
         
         <hr size="3">

		<b>Best Selling Items</b>
 		<table border="1">
 			<tr>
 				<td>Item</td><td>Number Sold</td><td>Total Earnings</td>
 			</tr>
 				<%
 				while(best_items.next()){%>
 					<tr>
 						<td><%=best_items.getString("item")%></td>
                        <td><%=best_items.getInt("num_sold")%></td>
 						<td><%=best_items.getFloat("total")%></td>
 					</tr>
 				<%}%>
 		</table>       

         <hr size="3">

		<b>Top Buyers</b>
 		<table border="1">
 			<tr>
 				<td>Username</td><td>Number of Purchases</td><td>Total Spent</td>
 			</tr>
 				<%
 				while(best_buyers.next()){%>
 					<tr>
 						<td><%=best_buyers.getString("username")%></td>
 						<td><%=best_buyers.getInt("num_purchases")%></td>
                        <td><%=best_buyers.getFloat("total")%></td>
 					</tr>
 				<%}%>
 		</table>

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

         <hr size="3">

         <a href='admin.jsp'>Return</a>
        <%
    }
    catch(Exception e) {
        out.print(e);
        response.sendRedirect("admin-report-error.jsp");
    }
    con.close();
    session.setAttribute("acctmsg","");
    
%>