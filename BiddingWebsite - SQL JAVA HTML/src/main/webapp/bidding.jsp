<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<%
ApplicationDB db = new ApplicationDB();	
Class.forName("com.mysql.jdbc.Driver");
Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BuyElectronics", "root", "Rootuser!1");	
Statement st = con.createStatement();
Statement stmt = con.createStatement();
    
    String item_id = request.getParameter("id");   
    String bid  = request.getParameter("bid");
    Boolean closedAuction = false;
 
    int id = Integer.parseInt(item_id);
    float buyer_bid = Float.parseFloat(bid);
    
    ResultSet rs;
    rs = st.executeQuery("Select * from auction where item_id=" + id );
   	
    if (!rs.next()) {
		out.println("Item does not exist");
		return;
    }
    int current_buyer = rs.getInt("buyer_id");
    float currentPrice =rs.getFloat("current_price");
    int seller_id = rs.getInt("seller_id");
    int auction_id = rs.getInt("auction_id");
    int temp_item_id = rs.getInt("item_id");
	String closing_date = rs.getString("closing_date");
    float current_price = rs.getFloat("current_price");
    float max_price = rs.getFloat("bid_limit");
    Boolean active = rs.getBoolean("auction_active");
    float seller_increment = rs.getFloat("increment");
    float newBid = current_price + seller_increment;
    
    if(buyer_bid < newBid){
    	out.println("Cannot bid at this price, please bid higher than: $" + newBid);
    	return;
    }
    if(buyer_bid > max_price){
    	out.println("Cannot bid at this price, please bid lower than: $" + max_price);
    	return;
    }
    
    
    String auct = "UPDATE auction SET current_price = ?, buyer_id=?, auction_active = ? WHERE auction_id = ?";
	PreparedStatement ps = con.prepareStatement(auct);
	
	String finauct = "UPDATE auction SET current_price = ?, buyer_id=?, auction_active = ?, sold_to_id = ? WHERE auction_id = ?";
	PreparedStatement ps6 = con.prepareStatement(finauct);
	int buyer_id= (Integer)session.getAttribute("account_num");
    if(buyer_bid == max_price){
    	ps6.setFloat(1, buyer_bid);
        ps6.setInt(2,buyer_id);
    	ps6.setBoolean(3, true);
    	closedAuction = true;
    	ps6.setInt(4, buyer_id);
    	ps6.setInt(5, auction_id);
    	ps6.executeUpdate();
    	
    }
    else{
    	ps.setFloat(1, buyer_bid);
        ps.setInt(2,buyer_id);
    	 ps.setBoolean(3, true);
    	 ps.setInt(4, auction_id);
    	 ps.executeUpdate();
    }

    try{
    	 String alert = "INSERT INTO alert VALUES(?,?,?,?,?)";
    		PreparedStatement al = con.prepareStatement(alert);
    		ResultSet aid = stmt.executeQuery("SELECT MAX(alert_id) as ID from alert");
    		aid.next();
    		int alertID = aid.getInt("ID") + 1;
    		al.setInt(1,alertID);
    		al.setInt(2,current_buyer);
    		al.setInt(3,temp_item_id);
    		al.setBoolean(4,true);
    		al.setString(5,"outbid");
    		al.executeUpdate();
    }
   catch(Exception e){
	   
   }
    
   
    	ResultSet rs4 = st.executeQuery("SELECT MAX(history_id) as ID from viewHistory");
		rs4.next();
		int accountID = rs4.getInt("ID") + 1;

    	String sql2 = "INSERT into viewHistory VALUES(?,?,?,?,?,?,?,?)";
    	PreparedStatement ps2 = con.prepareStatement(sql2);
		ps2.setInt(1,accountID);
   	 	ps2.setInt(2, seller_id);
    	ps2.setInt(3, buyer_id);
		ps2.setInt(4, auction_id);
		ps2.setInt(5, temp_item_id);
		ps2.setString(6, closing_date);
		ps2.setFloat(7,buyer_bid);
		
		if(closedAuction == true){
			ps2.setBoolean(8, false);
		}
		else{
		ps2.setBoolean(8, true);
		}
		
    
    	ps2.executeUpdate();

   
   %>
   Success, bid placed 
   <a href='welcome.jsp'>Go Back</a>