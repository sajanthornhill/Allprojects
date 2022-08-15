<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<%
    ApplicationDB db = new ApplicationDB();	
    Class.forName("com.mysql.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BuyElectronics", "root", "Rootuser!1");	
    Statement st = con.createStatement();
    ResultSet rs;
    String sql = "SELECT a.auction_id, e.model_Number as item_name, a.current_price as price FROM auction a JOIN electronic_item e USING (item_id)";
    rs = st.executeQuery(sql);
    try{
        %>
        <b>All Auctions:</b>
        <br>
 		<table border = 1>
            <tr>
                <th>Auction ID</th><th>Item Name</th><th>Current Price</th>
            </tr>
            <%
            while(rs.next()){%>
                <tr>
                    <td><%=rs.getInt("auction_id")%></td>
                    <td><%=rs.getString("item_name")%></td>
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

    <form action="bid-history-specific.jsp">
        <b>View Bid History for Specific Auction</b>
        <br><br>
        Auction ID:
        <input type="text" name="auctionid" size="10"/> 
        <input type="submit" value="Submit"/>
    </form>

    <br>

    <a href='welcome.jsp'>Go Back</a>