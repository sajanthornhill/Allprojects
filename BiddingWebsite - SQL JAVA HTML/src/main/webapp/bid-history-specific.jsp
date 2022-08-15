<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<%
    ApplicationDB db = new ApplicationDB();	
    Class.forName("com.mysql.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BuyElectronics", "root", "Rootuser!1");	
    Statement st = con.createStatement();
    String aid = request.getParameter("auctionid");
    ResultSet rs;
    String sql = "SELECT u.username as bidder, v.price FROM viewHistory v, users u WHERE v.user_account_id = u.account_id AND v.auction_id ='"+ aid +"' ORDER BY price DESC";
    rs = st.executeQuery(sql);
    try{
        %>
        <b>All Bids:</b>
        <br>
 		<table border = 1>
            <tr>
                <th>Bidder</th><th>Bid Amount</th>
            </tr>
            <%
            while(rs.next()){%>
                <tr>
                    <td><%=rs.getString("bidder")%></td>
                    <td><%=rs.getFloat("price")%></td>
                </tr>
            <%}%>
 		</table> 
         <%
    } catch(Exception e){
        out.print(e);
    }
    con.close();
    %>

    <br>

    <hr size="3">


    <a href='bid-history-auctions.jsp'>Go Back</a>