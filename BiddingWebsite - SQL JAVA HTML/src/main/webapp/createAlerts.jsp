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


String item_type = request.getParameter("id"); 

try{
	 
	ResultSet ia = st2.executeQuery("select * from electronic_item as e, auction as a where e.item_type = " + "'" + item_type + "'" + "and e.item_id = a.item_id and a.auction_active = true");
	
	if(ia.next()){
		
	
	while(ia.next()){
		int iid = ia.getInt("item_id");
		String alert = "INSERT INTO alert VALUES(?,?,?,?,?)";
		PreparedStatement al = con.prepareStatement(alert);

		ResultSet aid = st.executeQuery("SELECT MAX(alert_id) as ID from alert");
		aid.next();
		int accountID = aid.getInt("ID") + 1;

		al.setInt(1,accountID);
		al.setInt(2,(Integer)session.getAttribute("account_num"));
		al.setInt(3,iid);
		al.setBoolean(4,true);
		al.setString(5,"Item now available " + item_type);
		al.executeUpdate();
		
	}
	}
else{
	out.println("no items of that type available right now, will alert you if it is in the future");
	String alert = "INSERT INTO alert VALUES(?,?,null,?,?)";
	PreparedStatement al = con.prepareStatement(alert);

	ResultSet aid = st.executeQuery("SELECT MAX(alert_id) as ID from alert");
	aid.next();
	int accountID = aid.getInt("ID") + 1;

	al.setInt(1,accountID);
	al.setInt(2,(Integer)session.getAttribute("account_num"));
	al.setBoolean(3,false);
	al.setString(4,"Item now available " + item_type);
	al.executeUpdate();
}
}
catch(Exception e){
	out.println("no items of that type available right now, will alert you if it is in the future");
	String alert = "INSERT INTO alert VALUES(?,?,null,?,?)";
	PreparedStatement al = con.prepareStatement(alert);

	ResultSet aid = st.executeQuery("SELECT MAX(alert_id) as ID from alert");
	aid.next();
	int accountID = aid.getInt("ID") + 1;

	al.setInt(1,accountID);
	al.setInt(2,(Integer)session.getAttribute("account_num"));
	al.setBoolean(3,false);
	al.setString(4,"Item now available " + item_type);
	al.executeUpdate();
	
	
}
 %>
Alert Created 
   <a href='welcome.jsp'>Go Back</a>