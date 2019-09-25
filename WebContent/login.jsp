<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Login</title>
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
		
	


		String str = String.format("SELECT * FROM Account WHERE (AccountID = '%1$s') AND (Accountcol = '%2$s');", username, password);
				

		ResultSet result = stmt.executeQuery(str);		
	
				
		if (result.next()) {
			if(!username.toLowerCase().equals("admin") && !password.toLowerCase().equals("admin")){
				if(!"rep".equals(result.getString("type"))){

					session.setAttribute("name",request.getParameter("username"));
					response.sendRedirect("account.jsp");	
				}else{		
					session.setAttribute("name",request.getParameter("username"));
					response.sendRedirect("represenatative.jsp");			
				}
/* 			request.setAttribute("name", request.getParameter("username"));
			request.getRequestDispatcher("account.jsp").forward(request, response); */
			
			}else if(username.toLowerCase().equals("admin") && password.toLowerCase().equals("admin")){
				response.sendRedirect("admin.jsp");
			}
		}
		
		else{
			
			out.print("Login Failed!");

		}

		//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
		con.close();
		
		
	} catch (Exception ex) {
		out.print(ex);
	}
%>
</body>
</html>