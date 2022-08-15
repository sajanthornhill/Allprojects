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
Statement stmt2 = con.createStatement();
    
    String item_id = request.getParameter("id");   
    String bid  = request.getParameter("bid");
    String m_bid = request.getParameter("Maxbid");
    String i_bid = request.getParameter("bidincrement");
    Boolean closedAuction = false;
 
    int id = Integer.parseInt(item_id);
    float buyer_bid = Float.parseFloat(bid);
    float max_bid = Float.parseFloat(m_bid);
    float inc_bid = Float.parseFloat(i_bid);
    
    
    ResultSet rs;
    rs = st.executeQuery("Select * from auction where item_id= '" + item_id +"'");
   	
    if (!rs.next()) {
		out.println("Item does not exist");
		return;
    }
   	int current_buyer_alert = rs.getInt("buyer_id");
    float currentPrice =rs.getFloat("current_price");
    int seller_id = rs.getInt("seller_id");
    int auction_id = rs.getInt("auction_id");
    int temp_item_id = rs.getInt("item_id");
	String closing_date = rs.getString("closing_date");
    Float current_price = rs.getFloat("current_price");
    Float max_price = rs.getFloat("bid_limit");
    Boolean active = rs.getBoolean("auction_active");
    Float sellers_increment  = rs.getFloat("increment");
    
    if(sellers_increment> inc_bid){
    	inc_bid = sellers_increment;
    }
    
    float newBid = current_price + rs.getFloat("increment");
    
    if(buyer_bid < newBid){
    	out.println("Cannot bid at this price, please bid higher than: $" + newBid);
    	return;
    }
    if(buyer_bid > max_price){
    	out.println("Cannot bid at this price, please bid lower than: $" + max_price);
    	return;
    }
    if(buyer_bid > max_price){
    	out.println("You cannot make a maximum bid this high lower your maximum bid to $" + max_price);
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
    	ps6.setBoolean(3, false);
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
    
    String alert = "INSERT INTO alert VALUES(?,?,?,?,?)";
	PreparedStatement al = con.prepareStatement(alert);
	
	ResultSet aid = stmt.executeQuery("SELECT MAX(alert_id) as ID from alert");
	aid.next();
	int alertID = aid.getInt("ID") + 1;
	try{
		al.setInt(1,alertID);
		al.setInt(2,current_buyer_alert);
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

    	String viewHist = "INSERT into viewHistory VALUES(?,?,?,?,?,?,?,?)";
    	PreparedStatement ps2 = con.prepareStatement(viewHist);
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
    	
  try{
	  ResultSet c_max = stmt2.executeQuery("SELECT * from automatic_bid where auction_id =" + auction_id);
 		while(c_max.next()){
 		float current_max = c_max.getFloat("current_price");
 		int current_b = c_max.getInt("buyer_id");
 		if(current_max < max_bid){
 			String alert2 = "INSERT INTO alert VALUES(?,?,?,?,?)";
 	    	PreparedStatement al2 = con.prepareStatement(alert2);
 	    	
 	    	ResultSet aid2 = stmt.executeQuery("SELECT MAX(alert_id) as ID from alert");
 	    	aid2.next();
 	    	int alertID2 = aid2.getInt("ID") + 1;
 	    	
 	    	al2.setInt(1,alertID2);
 	    	al2.setInt(2,current_b);
 	    	al2.setInt(3,temp_item_id);
 	    	al2.setBoolean(4,true);
 	    	al2.setString(5,"Max Exceded");
 	    	al2.executeUpdate();
 		}
 	}
  }
  catch(Exception e){
	  
  }
    	
    	try{
    		String autoBid = "INSERT into automatic_bid VALUES(?,?,?,?,?,?)";
    		PreparedStatement ps3 = con.prepareStatement(autoBid);
    		ps3.setInt(1,auction_id);
    		ps3.setInt(2,buyer_id);
    		ps3.setInt(3,seller_id);
    		ps3.setInt(4, temp_item_id);
    		ps3.setFloat(5,max_bid);
    		ps3.setFloat(6,inc_bid);
    		ps3.executeUpdate();
    	}
    	catch(Exception ex){
    		out.println("You already set up an automatic bid! We've delete your previous" );
    		String delete = "DELETE FROM automatic_bid where buyer_id =" + buyer_id ;
    		PreparedStatement ps3 = con.prepareStatement(delete);
    		ps3.executeUpdate();
    		return;
    	}
    	
    	

   
   %>
   Automatic bidding activiated and bid placed 
   <a href='welcome.jsp'>Go Back</a>