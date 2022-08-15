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
    
	String item_MN = request.getParameter("model-name");
	
    String item_type = request.getParameter("item-type-value"); 
    
    String item_value = request.getParameter("sort-by-value");
    
    String sbv = "";
    if(item_value.equals("price")){
    	 sbv = "current_price";
    }
    else if(item_value.equals("year")){
    	 sbv = "item_year";
    }
    else{
    	 sbv = "item_type";
    }
    
    String min_price = request.getParameter("min-price");
    String max_price = request.getParameter("max-price");
    
    
    
    String cb_itemname = request.getParameter("item-name"); 
    String cb_sbc = request.getParameter("sort-by-check"); 
    String cb_itc = request.getParameter("item-type-check"); 
    String cb_prc = request.getParameter("price-range-check");
    String cb_sim = request.getParameter("similar");
    
    boolean bool1 = Boolean.parseBoolean(cb_itemname);
    boolean bool2 = Boolean.parseBoolean(cb_sbc);
    boolean bool3 = Boolean.parseBoolean(cb_itc);
    boolean bool4 = Boolean.parseBoolean(cb_prc);
    boolean bool5 = Boolean.parseBoolean(cb_sim);
    String query = "";

    if(bool5 == true){
         query = "select * from electronic_item as e, auction as a where e.item_id = a.item_id and closing_date > NOW() - INTERVAL 1 MONTH ";
    }
    else{
    	 query = "select * from electronic_item as e, auction as a where e.item_id = a.item_id and a.closing_date > NOW() and a.auction_active = a.auction_active ";
    }
    
    if(bool1 == true){
    	String temp1 = "and model_number = " + "'" + item_MN + "' ";
    	query = query + temp1;	
    }
    if(bool3 == true){
    	String temp2 = "and item_type = " + "'" + item_type + "' ";
    	query = query + temp2;
    }
    if(bool4 == true){
    	
    	if(!min_price.isEmpty()){
    		 int minInt = Integer.parseInt(min_price);
    		String min = "and current_price > "  + minInt + " ";
    		query = query + min;
    		
    	}
    	if(!max_price.isEmpty()){
    		int maxInt = Integer.parseInt(max_price);
    		String max = "and current_price < " + maxInt + " ";
    		query = query + max;
    	}
    	
    }
    if(bool2 == true){
    	String temp3 = "order by " + sbv;
    	query = query + temp3;
    	
    }
    
    
        

    ResultSet rs;
    rs = st.executeQuery(query);
    
    if (rs.next() == true) {
        session.setAttribute("item_Type", item_type); 
        %>
        <table border="1">
        <tr><th>item ID</th><th>Model Number</th><th>Item Type</th><th>Item Year</th><th>dimensions</th><th>memory</th><th>Specifications</th><th>Current Price</th><th>Closing Date</th></tr>
 				
 				<%
 				rs.previous();
 				while(rs.next()){%>
 				<%
 			    %>
 					<tr>
 						 <tr><td><%=rs.getInt("item_id")%></td>
 						 <td><%=rs.getString("model_number")%></td>
 						 <td><%=rs.getString("item_type")%></td>
 						 <td><%=rs.getString("item_year")%></td>
 						 <td><%=rs.getString("dimensions")%></td>
 						 <td><%=rs.getString("item_memory")%></td>
 						 <td><%=rs.getString("specifications")%></td>
 						 <td><%=rs.getFloat("current_price")%></td>
 						 <td><%=rs.getString("closing_date")%></td><tr>
 		
 				<%}%>
 				
 		
 		</table>       
         <form action = 'bidding.jsp', method="post">
	        <table>
	        <tr>
	        <td>Enter Item ID You want to Bid On</td><td><input type="text" name="id"></td>
	        </tr>
	        <tr>
	        <td>Enter Bid Amount</td><td><input type="text" name="bid"></td>
	        </tr>
	        </table>
	        <input type="submit" value="Submit Bid">
        </form>
        
        <form action = 'autobid.jsp', method="post">
	        <table>
	        <tr>
	        <td>Enter Item ID You want to automatically Bid On</td><td><input type="text" name="id"></td>
	        </tr>
	        <tr>
	        <td>Enter Current Bid Price</td><td><input type="text" name="bid"></td>
	        </tr>
	        <tr>
	        <td>Enter Max Bid Price</td><td><input type="text" name="Maxbid"></td>
	        </tr>
	        <tr>
	        <td>Enter own bid increment, if it's lower than the seller set it will be replaced</td><td><input type="text" name="bidincrement"></td>
	        </tr>
	        </table>
	        <input type="submit" value="Submit Automatic Bid">
        </form>
        
        
        
 <%
    }else {
        out.println("No items exist of that type on the market or your search was incorrect, SORRY!");
    }
    
    
    
    
    
    con.close();
%>
<a href='welcome.jsp'>Go Back</a>
