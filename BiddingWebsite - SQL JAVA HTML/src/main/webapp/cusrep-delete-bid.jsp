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

<%} else {
%>
Welcome <%=session.getAttribute("userID")%> <br><br>

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
      <p><a href='welcome.jsp'>Home</a><br><a href='logout.jsp'>Log out</a></p>
    </div>

<%
    ApplicationDB db = new ApplicationDB();	
    Class.forName("com.mysql.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/BuyElectronics", "root", "Rootuser!1");	
    Statement st = con.createStatement();
    
    int history_id = Integer.parseInt(request.getParameter("bidid"));   
    int seller_id = Integer.parseInt(request.getParameter("sellerid"));
    ResultSet rs;
    
    rs = st.executeQuery("Select * from viewHistory where history_id= '" + history_id + "' and seller_id ='" + seller_id + "'");
    if (rs.next()) {
    	//rs.previous();
    	int auction_id = rs.getInt("auction_id");
    	String sql = "delete from viewHistory where history_id = ?";
        PreparedStatement ps = con.prepareStatement(sql);
         
        ps.setInt(1, history_id);
        ps.executeUpdate();
        
        try{
        	ResultSet rs4 = st.executeQuery("Select MAX(history_id) as ID, price as p, user_account_id as b from viewHistory where auction_id = ? and seller_id = ?");
            rs4.next();
            float newprice = rs4.getFloat("p");
            int newid = rs4.getInt("b");
            
            String auct = "UPDATE auction SET current_price = ?, buyer_id=?, WHERE auction_id = ?";
        	PreparedStatement ps6 = con.prepareStatement(auct);
        	ps6.setFloat(1, newprice);
            ps6.setInt(2,newid);
            ps6.setInt(2,auction_id);
        	ps6.executeUpdate();
            
        	
        }
        catch(Exception e){
        	
        }
        
 		
        out.println("Successful!");
    }else {
        out.println("This bid does not exist!");
    } 
    
    con.close();
%>			
<a href='cusrep-home.jsp'>Go Back</a>
<%
}
%>