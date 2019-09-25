<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>AccountControl</title>
</head>
<body>

Admin Account control page
<br>
<form method="post">
<table>
	<tr>    
	<td>username</td><td><input type="text" name="username"></td>
	</tr>
	<tr>    
	<td>info</td><td><input type="text" name="info"></td>
	</tr>
	</table>
       <input type="submit" value="add" name ="button" /> 
       <input type="submit" value="edit" name ="button" /> 
       <input type="submit" value="delete(leave info blank)" name ="button" /> 
	</form>	
<br>


<%
String x = request.getParameter("button");
String username = request.getParameter("username");
String info = request.getParameter("info");

if("add".equals(x)){
	try {

		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		
 		//Make an insert statement for the Sells table:
		String insert = String.format("UPDATE Account SET info = '%2$s' WHERE AccountID = '%1$s'", username, info);
		//Create a Prepared SQL statement allowing you to introduce the parameters of the query
		PreparedStatement ps = con.prepareStatement(insert);
		
		//Run the query against the DB
		ps.executeUpdate(); 
		
		
		out.print("information added!");
		
		//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
		con.close();

		
	} catch (Exception ex) {
		out.print(ex);
		out.print("ERROR: Information not Added!");
	}
} else if("edit".equals(x)){
	try {

		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		
 		//Make an insert statement for the Sells table:
		String insert = String.format("UPDATE Account SET info = '%2$s' WHERE AccountID = '%1$s'", username, info);
		//Create a Prepared SQL statement allowing you to introduce the parameters of the query
		PreparedStatement ps = con.prepareStatement(insert);
		
		//Run the query against the DB
		ps.executeUpdate(); 
		
		
		out.print("information edited!");
		
		//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
		con.close();

		
	} catch (Exception ex) {
		out.print(ex);
		out.print("ERROR: Information not Edited");
	}	
	
} else if("delete(leave info blank)".equals(x)){
	
	   try {

			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();

			//Create a SQL statement
			Statement stmt = con.createStatement();
	
			String delete = String.format("UPDATE Account SET info = '' WHERE AccountID = '%1$s'", username);
				
			PreparedStatement ps = con.prepareStatement(delete);
			//Run the query against the DB
			ps.executeUpdate(); 
			
			
			out.print("Information deleted!");				
			
			//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
			con.close();

		} catch (Exception ex) {
			out.print("ERROR: Information not Deleted!");
		}
	
}
%>	

<form method="post" action="admin.jsp">
<button type="submit">return to admin page</button>
</form>
 
 
</body>
</html>