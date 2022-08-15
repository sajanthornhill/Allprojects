<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<%
    ApplicationDB db = new ApplicationDB();	
    Class.forName("com.mysql.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BuyElectronics", "root", "Rootuser!1");	
    Statement st = con.createStatement();
    Statement st2 = con.createStatement();
    String username = request.getParameter("user");
    ResultSet rs, rs2;
    String sql = "SELECT DISTINCT v.auction_id as Auction_ID, e.model_Number as Item_Name FROM electronic_item e JOIN viewHistory v USING (item_id), users u WHERE u.account_id = v.user_account_id and u.username='" + username + "'";
    rs = st.executeQuery(sql);
    String sql2 = "SELECT DISTINCT v.auction_id as Auction_ID, e.model_Number as Item_Name FROM electronic_item e JOIN viewHistory v USING (item_id), users u WHERE u.account_id = v.seller_id and u.username='" + username + "'";
    rs2 = st2.executeQuery(sql2);
    pageContext.setAttribute("uName", username);
    try{
        %>
        <b>Auctions that ${uName} bid in:</b>
        <br><br>
 		<table border="1">
            <tr>
                <td>Auction ID</td><td>Item Name</td>
            </tr>
            <%
            while(rs.next()){%>
                <tr>
                    <td><%=rs.getInt("Auction_ID")%></td>
                    <td><%=rs.getString("Item_Name")%></td>
                </tr>
            <%}%>
 		</table>

         <hr size="3">

        <b>Auctions that ${uName} sold in:</b>
        <br><br>
 		<table border="1">
            <tr>
                <td>Auction ID</td><td>Item Name</td>
            </tr>
 				<%
 				while(rs2.next()){%>
 					<tr>
                        <td><%=rs2.getInt("Auction_ID")%></td>
                        <td><%=rs2.getString("Item_Name")%></td>
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
    <br>

    <a href='welcome.jsp'>Go Back</a>