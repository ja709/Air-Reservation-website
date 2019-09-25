<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>My Upcoming Reservations List</title>
</head>
<body>
	<%

		out.print("My Upcoming Reservations List!");
	try {

		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();

		//Create a SQL statement
		Statement stmt = con.createStatement();
		
		String str = String.format("SELECT AirReservationSystem7.Flight.Flight_num AS Flight_num, price, Take_off_time, Landing_time, Num_stops, Airline, AirReservationSystem7.Flight.type AS type, AirReservationSystem7.CustomInfo.TicketID, Depart, Arrive FROM AirReservationSystem7.CustomInfo inner join AirReservationSystem7.Flight on AirReservationSystem7.CustomInfo.Flight_num=AirReservationSystem7.Flight.Flight_num WHERE AirReservationSystem7.CustomInfo.AccountID='%1$s' AND AirReservationSystem7.CustomInfo.type='F';", session.getAttribute("name"));
				
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
			out.print("TicketID");
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
				out.print(result.getString("TicketID"));
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
			out.print("No Reservations Found!");
		}
	
		//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
		con.close();
		
		
	} catch (Exception ex) {
		out.print(ex);
	}
%>
<form method="post">
<table>
<td>Flight</td><td><input type="text" name="flight_to_cancel" placeholder="821"></td>
<td>Ticket To Cancel</td><td><input type="text" name="ticket_to_cancel" placeholder="Jeeho123...."></td>
</table>
<input type="submit" value="cancel" name ="button" /> 
</form>	

 <% 
    String x = request.getParameter("button");
   if("cancel".equals(x))
   {
		try {

			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();

			//Create a SQL statement
			Statement stmt = con.createStatement();
			
			String flight = request.getParameter("flight_to_cancel");
			String ticket = request.getParameter("ticket_to_cancel");
			
			String str = String.format("SELECT AirReservationSystem7.Flight.type AS type, Available FROM AirReservationSystem7.CustomInfo inner join AirReservationSystem7.Flight on AirReservationSystem7.CustomInfo.Flight_num=AirReservationSystem7.Flight.Flight_num WHERE AirReservationSystem7.CustomInfo.AccountID='%1$s'AND AirReservationSystem7.CustomInfo.Flight_num = '%2$s' AND AirReservationSystem7.CustomInfo.type='F';", session.getAttribute("name"), flight);
					
			ResultSet result = stmt.executeQuery(str);		
			
			if(result.next()){
				
							
				if(!result.getString("type").equals("Economy")){
					
					String delete = String.format("DELETE FROM CustomInfo WHERE AccountID = '%1$s' AND Flight_num = '%2$s' AND type='F';", session.getAttribute("name"), flight);
					
					PreparedStatement ps = con.prepareStatement(delete);
					
					ps.executeUpdate(); 
					
					delete = String.format("DELETE FROM Ticket WHERE AccountID = '%1$s' AND Flight_num = '%2$s' AND TicketID = '%3$s';", session.getAttribute("name"), flight, ticket);
						
					ps = con.prepareStatement(delete);
						
					ps.executeUpdate(); 
					
					int temp_available = Integer.parseInt(result.getString("Available").toString());
					
					temp_available = temp_available + 1;
					
					String update = String.format("UPDATE AirReservationSystem7.Flight SET Available = '%1$s' WHERE Flight_num = '%2$s';", temp_available, flight);

					ps = con.prepareStatement(update);

					//Run the query against the DB
					ps.executeUpdate(); 
					
					
					out.print("Reservation Cancelled!");	
					
				}else{
					out.print("Cannot Cancel an Economy Reservation!");
				}
				
				
			}else{
				out.print("Flight Not Found!");
			}
				
		
			//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
			con.close();
			
			
		} catch (Exception ex) {
			out.print(ex);
		}
		
   }
%>
<form method="post" action="index.jsp">
<button type="submit">return to login page</button>
</form>

</body>
</html>