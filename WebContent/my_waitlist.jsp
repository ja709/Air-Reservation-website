<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>My Wait List</title>
</head>
<body>
	<%

		out.print("My Wait List!");
	try {

		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();

		//Create a SQL statement
		Statement stmt = con.createStatement();
		
		String str = String.format("SELECT AirReservationSystem7.Flight.Flight_num AS Flight_num, price, Take_off_time, Landing_time, Num_stops, Airline, AirReservationSystem7.Flight.type AS type, Available, Depart, Arrive FROM AirReservationSystem7.CustomInfo inner join AirReservationSystem7.Flight on AirReservationSystem7.CustomInfo.Flight_num=AirReservationSystem7.Flight.Flight_num WHERE AirReservationSystem7.CustomInfo.AccountID='%1$s' AND AirReservationSystem7.CustomInfo.type='W';", session.getAttribute("name"));
				
		ResultSet result = stmt.executeQuery(str);		
		if(result.next()){
			
			result.beforeFirst();
			//Make an HTML table to show the results in:
			out.print("<table>");

			//make a row
			out.print("<tr>");
			//make a column
			out.print("<td>");	
			out.print("Flight_num");
			out.print("</td>");
            out.print("<td>");	
			out.print("price");
			out.print("</td>");
            out.print("<td>");	
			out.print("Take_off_time");
			out.print("</td>");
            out.print("<td>");	
			out.print("Landing_time");
			out.print("</td>");
            out.print("<td>");	
			out.print("Num_stops");
			out.print("</td>");
            out.print("<td>");	
			out.print("Airline");
			out.print("</td>");
            out.print("<td>");	
			out.print("type");
			out.print("</td>");
            out.print("<td>");	
			out.print("Available");
			out.print("</td>");
            out.print("<td>");	
			out.print("Depart");
			out.print("</td>");
            out.print("<td>");	
			out.print("Arrive");
			out.print("</td>");
			out.print("</tr>");

			//parse out the results
			while (result.next()) {
				//make a row
				out.print("<tr>");
				//make a column
				out.print("<td>");
				out.print(result.getString("Flight_num"));
				out.print("</td>");
				out.print("<td>");
				out.print(result.getString("price"));
				out.print("</td>");
			    out.print("<td>");	
				out.print(result.getString("Take_off_time"));
				out.print("</td>");
                out.print("<td>");	
				out.print(result.getString("Landing_time"));
				out.print("</td>");
                out.print("<td>");	
				out.print(result.getString("Num_stops"));
				out.print("</td>");
                out.print("<td>");	
				out.print(result.getString("Airline"));
				out.print("</td>");
                out.print("<td>");	
				out.print(result.getString("type"));
				out.print("</td>");
                out.print("<td>");	
				out.print(result.getString("Available"));
				out.print("</td>");
                out.print("<td>");	
				out.print(result.getString("Depart"));
				out.print("</td>");
                out.print("<td>");	
				out.print(result.getString("Arrive"));
				out.print("</td>");
				out.print("</tr>");

			}
			
			out.print("</table>");
			
			
		}else{
			out.print("No Flights Found!");
		}
	
		//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
		con.close();
		
		
	} catch (Exception ex) {
		out.print(ex);
	}
%>
	<form method="post" action="index.jsp">
	<button type="submit">return to login page</button>
	</form>

</body>
</html>