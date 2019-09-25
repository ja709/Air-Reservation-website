<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<%
	try {

		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();

		//Create a SQL statement
		Statement stmt = con.createStatement();

		//Get parameters from the HTML form at the HelloWorld.jsp
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String is_rep = null;

		
		try{
		 is_rep = request.getParameter("is_rep");
		}
			catch(Exception ex){
				
				is_rep = null;
				
	
		}
		
		if(is_rep == null){
			is_rep = "null";
		}
		
 		//Make an insert statement for the Sells table:
		String insert = "INSERT INTO Account(AccountID, Accountcol, type)"
				+ "VALUES (?, ?, ?)";
		//Create a Prepared SQL statement allowing you to introduce the parameters of the query
		PreparedStatement ps = con.prepareStatement(insert);

		//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
		ps.setString(1, username.toLowerCase());
		ps.setString(2, password.toLowerCase());
		ps.setString(3, is_rep.toLowerCase());

		//Run the query against the DB
		ps.executeUpdate(); 
		
		
		out.print("Account Creation Successful!");
		
		
		
		//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
		con.close();

		
	} catch (Exception ex) {

/* 	    String redirectURL = "insertfailed.jsp";
	    response.sendRedirect(redirectURL);
 */
		out.print("Username already exists!");
	}
%>	
	<form method="post" action="index.jsp">
	<button type="submit">return to login page</button>
	</form>

</body>
</html>