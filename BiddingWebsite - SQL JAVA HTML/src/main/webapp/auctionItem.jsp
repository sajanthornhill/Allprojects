<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.util.Date.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%
ApplicationDB db = new ApplicationDB();	
Class.forName("com.mysql.jdbc.Driver");
Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BuyElectronics", "root", "Rootuser!1");	
Statement st = con.createStatement();



String tempmodel_number = request.getParameter("model_number");
int model_number = Integer.parseInt(tempmodel_number);

String item_type = request.getParameter("itemType");
item_type = item_type.toLowerCase();

String temps_price = request.getParameter("startingPrice");
float starting_price = Float.parseFloat(temps_price);

String tempm_price = request.getParameter("minPrice");
float min_price = Float.parseFloat(tempm_price);

String tempmax_price = request.getParameter("maxPrice");
float max_price = Float.parseFloat(tempmax_price);

String item_dim = request.getParameter("dimensions");
String item_specs = request.getParameter("specifications");
String item_mem = request.getParameter("memory");

String year = request.getParameter("year");

String temp_BidIncre = request.getParameter("bidIncrement");
float bid_increment = Float.parseFloat(temp_BidIncre);

String closing_date = request.getParameter("closing_date");




//java.text.SimpleDateFormat format = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
//java.util.Date endDateTime = format.parse(strEndDateTime);

ResultSet rs = st.executeQuery("SELECT MAX(item_id) as ID from electronic_item");
rs.next();
int id_number = rs.getInt("ID") + 1;

String create_item = "INSERT INTO electronic_item(item_id, model_Number, item_type, item_year, dimensions, item_memory, specifications)" + 
"VALUES (?,?,?,?,?,?,? )";
PreparedStatement item_ps = con.prepareStatement(create_item);

try{
	item_ps.setInt(1, id_number);
	item_ps.setInt(2, model_number);
	item_ps.setString(3, item_type);
	item_ps.setString(4, year);
	item_ps.setString(5, item_dim);
	item_ps.setString(6, item_specs);
	item_ps.setString(7, item_mem);

	item_ps.executeUpdate();
}
catch(Exception e)
{
	
}




ResultSet rs2 = st.executeQuery("SELECT MAX(auction_id) as ID from auction");
rs2.next();
int auction_id = rs2.getInt("ID") + 1;
String create_auction = "INSERT INTO auction(auction_id, buyer_id, seller_id, item_id, closing_date, starting_price, min_price, increment, bid_limit, current_price, auction_active, sold_to_id)" + 
"VALUES (?,null,?,?,?,?,?,?,?,?,?,null)";
PreparedStatement auction_ps = con.prepareStatement(create_auction);

auction_ps.setInt(1, auction_id);
auction_ps.setInt(2, (Integer) session.getAttribute("account_num"));
auction_ps.setFloat(3, id_number);
auction_ps.setString(4, closing_date);
auction_ps.setFloat(5, starting_price);
auction_ps.setFloat(6, min_price);
auction_ps.setFloat(7, bid_increment);
auction_ps.setFloat(8, max_price);
auction_ps.setFloat(9, starting_price);
auction_ps.setBoolean(10, true);

auction_ps.executeUpdate();

ResultSet rsA;
rsA = st.executeQuery("select * from alert where alert_type = 'Item now available " + item_type + "'" + " and alert_active = false" );

try{
	while(rsA.next()){
		int account_to_alert =  rsA.getInt("account_id");
		String alert = "INSERT INTO alert VALUES(?,?,?,?,?)";
		PreparedStatement al = con.prepareStatement(alert);

		ResultSet aid = st.executeQuery("SELECT MAX(alert_id) as ID from alert");
		aid.next();
		int accountID = aid.getInt("ID") + 1;

		al.setInt(1,accountID);
		al.setInt(2,account_to_alert);
		al.setInt(3,id_number);
		al.setBoolean(4,true);
		al.setString(5,"Item now available " + item_type);
		al.executeUpdate();
	}
}
catch(Exception e){
	
}
	


%>
Succesfully added item for sale, 
<%=session.getAttribute("userID")%>
<a href='welcome.jsp'>Go Back</a>

<%
con.close();
%>