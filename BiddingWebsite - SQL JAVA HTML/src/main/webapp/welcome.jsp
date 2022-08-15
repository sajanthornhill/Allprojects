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
<%	} else {
%>

		Welcome <%=session.getAttribute("userID")%>
		<br><b><br>
		<style> 
			.footer {
				position: fixed;
				height: 150px;
				left: 0;
				bottom: 0;
				width: 100%;
				font-size: 30;
				background-color: rgb(211, 208, 208);
				color: white;
				text-align: center;}
			body{
				margin-bottom: -150px;
			} 
		</style>

		<div class="footer"> 
			<p><a href='welcome.jsp'>Home</a><br><a href='logout.jsp'>Log out</a></p>
		</div>

		<hr size="3">

		<b>PUT UP ITEMS FOR SALE</b>
		<form action = 'auctionItem.jsp', method="POST">
			Model Number: <input type="text" name="model_number"/> <br/>
			Year: <input type="text" name="year"/> <br/>
			Type of Item(Monitor, Laptop or Desktop): <input type="text" name="itemType"/> <br/>
			Dimensions: <input type="text" name="dimensions"/> <br/>
			Specifications:<input type="text" name="specifications"/> <br/>
			Memory: <input type="text" name="memory"/> <br/>
			Starting Price of item: <input type="text" name="startingPrice"/> <br/>
			Minimum price that item will be sold at: <input type="text" name="minPrice"/> <br/>
			Maximum price that item will be sold at: <input type="text" name="maxPrice"/> <br/>
			Bid increment: <input type="text" name="bidIncrement"/> <br/>
			Closing date (YYYY-MM-DD HH:MM:SS): <input type="text" name="closing_date"/> <br/>
			<input type="submit" value="Post Item"/>
		</form>


		<hr size="3">

		<form action="searchItemtype.jsp">
		<b>SEARCH FOR ITEMS</b><br>
			<table>
				<tr>
					<input type = "checkbox" name = "item-name" value = "true"/> Item Name:
					<input type="text" name="model-name"/>
				</tr><br>
				<tr>
					<input type = "checkbox" name = "similar" value = "true"/> Similar Items in the preceding month:
				</tr><br>
				<tr>
					<input type = "checkbox" name = "sort-by-check" value = "true" /> Sort by:
					<select name="sort-by-value">
						<option value="price">Price</option>
						<option value="year">Year</option>
						<option value="type">Item Type</option>
					</select>
				</tr><br>
				<tr>
					<input type = "checkbox" name = "item-type-check" value = "true" /> Item Type:
					<select name="item-type-value">
						<option value="monitor">Monitor</option>
						<option value="laptop">Laptop</option>
						<option value="desktop">Desktop</option>
					</select>
				</tr><br>
				<tr>
					<input type = "checkbox" name = "price-range-check" value = "true"/> Price Range:
					<input type="text" name="min-price" size="10"/> to 
					<input type="text" name="max-price" size="10"/>
				</tr>
			</table>
			<input type="submit" value="Submit">
		</form>

		<hr size="3">

		<form action="bid-history-auctions.jsp">
		<b>VIEW BID HISTORY</b>
			<input type="submit" value="Submit"/>
		</form>

		<hr size="3">

		<form action="bid-history-users.jsp">
		<b>VIEW AUCTIONS ASSOCIATED WITH USER:</b>
			<input type="text" name="user"/><br>
			<input type="submit" value="Submit"/>
		</form>

<%
		ApplicationDB db = new ApplicationDB();	
		Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BuyElectronics", "root", "Rootuser!1");	
		
		Statement st = con.createStatement();
		Statement st2 = con.createStatement();
		Statement st8 = con.createStatement();
		Statement stmt = con.createStatement();
		
		int current_user = (Integer)session.getAttribute("account_num");
		ResultSet rs = st.executeQuery("SELECT * from automatic_bid where buyer_id =" + current_user);
		if(rs.next() == true){
			int item_id = rs.getInt("item_id");
			float max_bid = rs.getFloat("current_price");
			int seller_id = rs.getInt("seller_id");
			float buyer_increment = rs.getFloat("increment");
			
			ResultSet rs2 = st2.executeQuery("SELECT * from auction where auction_active = true and item_id =" + item_id);
			if(rs2.next() == true){
				int auction_current_buyer = rs2.getInt("buyer_id");
				String closing_date = rs2.getString("closing_date");
				int current_auction = rs2.getInt("auction_id");
				Float auction_price = rs2.getFloat("current_price");
				Float bid_increment = rs2.getFloat("increment");
				Float max_price = rs2.getFloat("bid_limit");
				
				if(auction_current_buyer != current_user){
					if(auction_price + buyer_increment > max_price || max_bid < auction_price){
						out.println("Automatic Bidding has ended, you must adjust you automatic bidding max value if you want to continue");
					}
					String placeAutoBid = "UPDATE auction SET current_price = ?, buyer_id =? WHERE item_id = ?";
					PreparedStatement ps = con.prepareStatement(placeAutoBid);
					ps.setFloat(1, auction_price + buyer_increment);
					ps.setInt(2,current_user);
					ps.setInt(3, item_id);
					ps.executeUpdate();
					String viewhist = "INSERT into viewHistory VALUES(?,?,?,?,?,?,?,?)";
					PreparedStatement ps2 = con.prepareStatement(viewhist);
					
					ResultSet rs4 = st.executeQuery("SELECT MAX(history_id) as ID from viewHistory");
					rs4.next();
					int accountID = rs4.getInt("ID") + 1;
					ps2.setInt(1,accountID);
					ps2.setInt(2, seller_id);
					ps2.setInt(3, current_user);
					ps2.setInt(4, current_auction);
					ps2.setInt(5, item_id);
					ps2.setString(6, closing_date);
					ps2.setFloat(7,auction_price + buyer_increment);
					ps2.setBoolean(8, true);
					ps2.executeUpdate();
				}
			}
		}
		//Update table
		Statement st3 = con.createStatement();
		ResultSet updateTables = st3.executeQuery("Select * FROM auction WHERE closing_date < NOW() and auction_active = true or bid_limit = current_price and auction_active = true");
		
		while(updateTables.next()){
			
			int item_id = updateTables.getInt("item_id");
			int buyer_id = updateTables.getInt("buyer_id");
			int seller_id = updateTables.getInt("seller_id");
			int auction_id = updateTables.getInt("auction_id");
			float min_price = updateTables.getFloat("min_price");
			float current_price = updateTables.getInt("current_price");	
			if(current_price >= min_price){
				String sold = "UPDATE auction SET sold_to_id = " + buyer_id + " WHERE auction_id = ?";
				PreparedStatement ps7 = con.prepareStatement(sold);
				ps7.setInt(1,auction_id);
				ps7.executeUpdate();
				
				String alert = "INSERT INTO alert VALUES(?,?,?,?,?)";
				PreparedStatement al = con.prepareStatement(alert);
				try{
					ResultSet aid = stmt.executeQuery("SELECT MAX(alert_id) as ID from alert");
					aid.next();
					int accountID = aid.getInt("ID") + 1;
					
					al.setInt(1,accountID);
					al.setInt(2,buyer_id);
					al.setInt(3,item_id);
					al.setBoolean(4,true);
					al.setString(5,"Item won");
					al.executeUpdate();
				}
				catch(Exception e){
					
				}
				
			}
		
			Statement st4 = con.createStatement();
			String s = String.valueOf(auction_id);
			String auctionExpire = "UPDATE auction SET auction_active = false WHERE auction_id = ? ";
			PreparedStatement auctUp = con.prepareStatement(auctionExpire);
			auctUp.setInt(1,auction_id);
			auctUp.executeUpdate();
			String viewhist = "UPDATE viewhistory SET auction_active = false WHERE item_id = ? and user_account_id = ? and seller_id = ? and auction_id = ?";
			PreparedStatement ps7 = con.prepareStatement(viewhist);	
			ps7.setInt(1,item_id);
			ps7.setInt(2,buyer_id);
			ps7.setInt(3,seller_id);
			ps7.setInt(4,auction_id);
			ps7.executeUpdate();
		}
		
		String auctionExpire = "UPDATE auction SET auction_active = false WHERE closing_date < NOW() ";
		PreparedStatement auctUp = con.prepareStatement(auctionExpire);
		auctUp.executeUpdate();
		
   
		ResultSet at;
		at = st8.executeQuery("select * from alert where alert_active = true and account_id = " + (Integer)session.getAttribute("account_num") );
		if (at.next() == true) { 
			%>
			<table border="1">
			<tr><th>alert ID</th>
				<th>Account ID</th>
				<th>Item ID</th>
				<th>Alert _Type</th>
			</tr>
			<%
			at.previous();
			while(at.next()){
%>
				<tr><td><%=at.getInt("alert_id")%></td>
					<td><%=at.getInt("account_id")%></td>
					<td><%=at.getInt("item_id")%></td>
					<td><%=at.getString("alert_type")%></td>
				</tr>
<%
			}
%>

			</table>   

			<form action = 'clearAlerts.jsp', method="post">
				<input type="submit" value="Clear Alerts">
			</form>  
<%
		} else {
			out.println("You have no alerts right now");
		}
%>
		<form action = 'createAlerts.jsp', method="post">
			<table>
			<tr>
				<td>Create an alert for when a type of item becomes available(Laptop, Desktop or Monitor)</td>
				<td><input type="text" name="id"></td>
			</tr>
			</table>
			<input type="submit" value="Submit value">
		</form>

		<hr size="3">

		<b>LOOK AT QUESTIONS (PRESS CONTINUE TO SEE ALL ENTRIES</b>
		<form action = 'qna-show.jsp', method="POST">
			<input type="submit" value="Continue"/>
		</form>	

<%
	}
%>