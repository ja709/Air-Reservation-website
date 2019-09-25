<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Represenantive</title>
</head>
<body>
<%	out.print("Represenative Account of "); 
	out.print(session.getAttribute("name"));
%>
<br>
	<form method="post">
	<input type="submit" value="logout" name ="button" />
	</form>    	
<br>
---------------Representative Customer help panel---------------
<br>
<form method="post">
<table>
	<tr>    
	<td>Flight</td><td><input type="text" name="flight"></td>
	</tr>
	<tr>
	<td>Account</td><td><input type="text" name="account"></td>
	</tr>
	<tr>    
	<td>Type</td><td><input type="text" name="type"></td>
	</tr>
	</table>
       <input type="submit" value="add" name ="button" /> 
       <input type="submit" value="edit" name ="button" /> 
       <input type="submit" value="retrieve_waitlist" name ="button" /> 
	</form>	
<br>
---------------Representative control panel---------------
<br>
FIX AIRPORT
<br>
<br>
	<form method="post">
	<table>
	<tr>    
	<td>AirportID</td><td><input type="text" name="AirportID"></td>
	</tr>
	<tr>
	<td>AirportName</td><td><input type="text" name="AirportName"></td>
	</tr>
	</table>
	<input type="submit" value="add" name = "push"/>
	<input type="submit" value="edit" name = "push"/>
	<input type="submit" value="delete" name = "push"/>
	</form>
<br>
<br>
FIX Aircrafts
<br>
<br>
	<form method="post">
	<table>
	<tr>    
	<td>Aircraft</td><td><input type="text" name="Aircraft"></td>
	<td>edit existing</td><td><input type="text" name="edit"></td>
	</tr>
	</table>
	<input type="submit" value="add" name = "push2"/>
	<input type="submit" value="edit" name = "push2"/>
	<input type="submit" value="delete" name = "push2"/>
	</form>
<br>
<br>
FIX Flights
<br>
<br>
	<form method="post">
	<table>
	<tr>    
	<td>Flight#</td><td><input type="text" name="Flight_num" placeholder="3245"></td>
	</tr>
	<tr>    
	<td>Price</td><td><input type="text" name="Price" placeholder="1000"></td>
	</tr>
	<tr>    
	<td>Take off time</td><td><input type="text" name="Take_time" placeholder="2019-08-01 07:00:00"></td>
	</tr>
	<tr>    
	<td>Landing time</td><td><input type="text" name="Landing_time" placeholder="2019-08-01 10:10:00"></td>
	</tr>
	<tr>    
	<td>Number of Stops</td><td><input type="text" name="Num_Stops" placeholder="nonstop"></td>
	</tr>
	<tr>    
	<td>Airline</td><td><input type="text" name="Airline" placeholder="Uninted Airline"></td>
	</tr>
	<tr>
	<td>Type</td><td><input type="text" name="Type" placeholder="Economy"></td>
	</tr>
	<tr>
	<td>Available seats</td><td><input type="text" name="Available" placeholder="3"></td>
	</tr>
	<tr>
	<td>Depart</td><td><input type="text" name="Depart" placeholder="JFK"></td>
	</tr>
	<tr>
	<td>Arrive</td><td><input type="text" name="Arrive" placeholder="ICN"></td>
	</tr>

	</table>
	<input type="submit" value="add" name = "push3"/>
	<input type="submit" value="edit" name = "push3"/>
	<input type="submit" value="delete(enter Flight#)" name = "push3"/>
	</form>
<br>


       <% String x = request.getParameter("button");
   if("add".equals(x)) {
		try {

			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();

			//Create a SQL statement
			Statement stmt = con.createStatement();

			//Get parameters from the HTML form at the HelloWorld.jsp
			String account = request.getParameter("account");
			String flight = request.getParameter("flight");
			String type = request.getParameter("type");
			
			String timestamp = System.currentTimeMillis() / 1000L + "";
						
			
			String query = String.format("SELECT * FROM AirReservationSystem7.Flight WHERE Flight_num = '%1$s'", flight);

			ResultSet result = stmt.executeQuery(query);	
			
			if(result.next()){
				
				if(!result.getString("Available").toString().equals("0")){
						type = "F";
						
						int temp_available = Integer.parseInt(result.getString("Available").toString());
						temp_available = temp_available - 1;
						String update = String.format("UPDATE AirReservationSystem7.Flight SET Available = '%1$s' WHERE Flight_num = '%2$s'", temp_available, flight);

						PreparedStatement ps = con.prepareStatement(update);

						//Run the query against the DB
						ps.executeUpdate(); 
							
					    String insert = "INSERT INTO Ticket(TicketID, Flight_num, AccountID, Fare)"
								+ "VALUES (?, ?, ?, ?)";
						//Create a Prepared SQL statement allowing you to introduce the parameters of the query
						ps = con.prepareStatement(insert);

						//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
						ps.setString(1, account.toString().toLowerCase() + timestamp);
						ps.setString(2, flight.toLowerCase());
					    ps.setString(3, account.toString().toLowerCase());
					    ps.setString(4, result.getString("price").toString());
						//Run the query against the DB
					    ps.executeUpdate(); 
						
						
						 insert = "INSERT INTO CustomInfo(type, Flight_num, AccountID, TicketID)"
								+ "VALUES (?, ?, ?, ?)";
						//Create a Prepared SQL statement allowing you to introduce the parameters of the query
						 ps = con.prepareStatement(insert);
			
						//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
						ps.setString(1, type.toLowerCase());
						ps.setString(2, flight.toLowerCase());
					    ps.setString(3, account.toString().toLowerCase());
					    ps.setString(4, account.toString().toLowerCase() + timestamp);
					    
						//Run the query against the DB
					    ps.executeUpdate(); 
			
					   	out.print("Reservation added for flight " + flight + " ");

				}else{
					type = "W";
			 		//Make an insert statement for the Sells table:
					String insert = "INSERT INTO CustomInfo(type, Flight_num, AccountID)"
							+ "VALUES (?, ?, ?)";
					//Create a Prepared SQL statement allowing you to introduce the parameters of the query
					PreparedStatement ps = con.prepareStatement(insert);
		
					//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
					ps.setString(1, type.toLowerCase());
					ps.setString(2, flight.toLowerCase());
					ps.setString(3, session.getAttribute("name").toString().toLowerCase());
					//Run the query against the DB
					ps.executeUpdate(); 

					out.print("Waitlisted for flight " + flight + " ");
				}

			
			
			}else{

				out.print("Flight " + flight + " Not Found!");
				
			}
			
			//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
			con.close();

			
		} catch (Exception ex) {
			
			out.print("Flight/Account Not Found!");
		}
   }else if("edit".equals(x)){
	   try {

			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();

			//Create a SQL statement
			Statement stmt = con.createStatement();

			//Get parameters from the HTML form at the HelloWorld.jsp
			String account = request.getParameter("account");
			String flight = request.getParameter("flight");
			String type = request.getParameter("type");
			
			
			
	 		//Make an insert statement for the Sells table:
	 			
	 		String update = String.format("UPDATE CustomInfo SET Flight_num = '%1$s' WHERE AccountID = '%2$s'", flight, account);

			PreparedStatement ps = con.prepareStatement(update);

			//Run the query against the DB
			ps.executeUpdate(); 
			
			
			out.print("Reservation Edited!");
			
			
			//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
			con.close();

			
		} catch (Exception ex) {
			
			out.print(ex);
			
			out.print("Flight/Account Not Found!");
		}
   }else if("retrieve_waitlist".equals(x)){
	   try {

			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();

			//Create a SQL statement
			Statement stmt = con.createStatement();

			//Get parameters from the HTML form at the HelloWorld.jsp

			String flight = request.getParameter("flight");
			
			
			
/* 	 		//Make an insert statement for the Sells table:
	 			
	 		String update = String.format("UPDATE CustomInfo SET Flight_num = '%1$s' WHERE AccountID = '%2$s'", fligh);

			PreparedStatement ps = con.prepareStatement(update);

			//Run the query against the DB
			ps.executeUpdate(); 
			 */
			
				String str = String.format("SELECT AccountID FROM CustomInfo WHERE ( Flight_num = '%1$s') AND (type = 'w');", flight);
				

				ResultSet result = stmt.executeQuery(str);		
				
				if(result.next()){
					result.beforeFirst();
					//Make an HTML table to show the results in:
					out.print("<table>");
					
					//make a row
					out.print("<tr>");
					//make a column
					out.print("<td>");
					
					out.print("Account");
					
					out.print("</td>");
					//make a column
					out.print("<td>");


					out.print("</td>");
					out.print("</tr>");

					//parse out the results
					while (result.next()) {
						//make a row
						out.print("<tr>");
						//make a column
						out.print("<td>");
						//Print out current bar or beer name:
						out.print(result.getString("AccountID"));
						out.print("</td>");
						out.print("</tr>");

					}
					
					out.print("</table>");
					
					
				}else{
					out.print("No Waitlist Found!");
				}
			
			
			//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
			con.close();

			
		} catch (Exception ex) {
			
			
			out.print("Flight Not Found!");
		}
		
	}else if("logout".equals(x)){
		session.setAttribute("name", null);
		response.sendRedirect("index.jsp");	
	}
	%> 
  
 
 
	<% String x1 = request.getParameter("push");
   if("add".equals(x1)) {
		try {

			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();

			//Create a SQL statement
			Statement stmt = con.createStatement();

			//Get parameters from the HTML form at the HelloWorld.jsp
			String AirportID = request.getParameter("AirportID");
			String AirportName = request.getParameter("AirportName");	
						
	 		//Make an insert statement for the Sells table:
			String insert = "INSERT INTO Airport(id, name)"
					+ "VALUES (?, ?)";
			//Create a Prepared SQL statement allowing you to introduce the parameters of the query
			PreparedStatement ps = con.prepareStatement(insert);

			//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
			ps.setString(1, AirportID.toUpperCase());
			ps.setString(2, AirportName.toLowerCase());
			//Run the query against the DB
			ps.executeUpdate(); 
			
			
			out.print("Airport Added!");
			
			
			//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
			con.close();

			
		} catch (Exception ex) {
			
			out.print("Error, Airport not added!");
		}
   }else if("edit".equals(x1)){
	   try {

			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();

			//Create a SQL statement
			Statement stmt = con.createStatement();

			//Get parameters from the HTML form at the HelloWorld.jsp
			String AirportID = request.getParameter("AirportID");
			String AirportName = request.getParameter("AirportName");
			
			//String search = string.format("SELECT id FROM Airport");
			//if()

	 		//Make an insert statement for the Sells table:			
	 			
	 		String update = String.format("UPDATE Airport SET id = '%1$s' WHERE name = '%2$s'", AirportID, AirportName);

			PreparedStatement ps = con.prepareStatement(update);

			//Run the query against the DB
			ps.executeUpdate(); 
			
			
			out.print("Airport Edited!");
			
			
			//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
			con.close();

			
		} catch (Exception ex) {
			
			out.print(ex);
			
			out.print("Error, Airport not edited!");
		}
   }else if("delete".equals(x1)){
	   try {

			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();

			//Create a SQL statement
			Statement stmt = con.createStatement();

			//Get parameters from the HTML form at the HelloWorld.jsp
			String AirportID = request.getParameter("AirportID");
			String AirportName = request.getParameter("AirportName");
			
			String delete = String.format("DELETE FROM Airport WHERE id = '%1$s' OR name = '%2$s';", AirportID, AirportName);
				
			PreparedStatement ps = con.prepareStatement(delete);
			//Run the query against the DB
			ps.executeUpdate(); 
			
			
			out.print("Airport deleted!");				
			
			//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
			con.close();

		} catch (Exception ex) {
			
			
			out.print("Airport Not Found!");
		}
	}
%>  
 
 
	<% String x2 = request.getParameter("push2");
	String Aircraft = request.getParameter("Aircraft");
	String edit = request.getParameter("edit");
	if("add".equals(x2)) {
		try {

			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();

			//Create a SQL statement
			Statement stmt = con.createStatement();

			//Get parameters from the HTML form at the HelloWorld.jsp
						
	 		//Make an insert statement for the Sells table:
			String insert = "INSERT INTO Aircraft(Model_ID)"
					+ "VALUES (?)";
			//Create a Prepared SQL statement allowing you to introduce the parameters of the query
			PreparedStatement ps = con.prepareStatement(insert);

			//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
			ps.setString(1, Aircraft.toLowerCase());
			//Run the query against the DB
			ps.executeUpdate(); 
			
			
			out.print("Aircraft Added!");
			
			
			//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
			con.close();

			
		} catch (Exception ex) {
			
			out.print("ADD: Aircraft Not Found!");
		}
   }else if("edit".equals(x2)){
	   try {

			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();

			//Create a SQL statement
			Statement stmt = con.createStatement();

			
	 		//Make an insert statement for the Sells table:			
	 			
	 		String update = String.format("UPDATE Aircraft SET Model_ID = '%1$s' WHERE Model_ID = '%2$s'", Aircraft, edit);

			PreparedStatement ps = con.prepareStatement(update);

			//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
			//Run the query against the DB
			ps.executeUpdate(); 
			
			
			out.print("Aircraft Edited!");
			
			
			//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
			con.close();

			
		} catch (Exception ex) {
			
			out.print(ex);
			
			out.print("EDIT: Aircraft not edited!");
		}
   }else if("delete".equals(x2)){
	   try {

			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();

			//Create a SQL statement
			Statement stmt = con.createStatement();

			//Get parameters from the HTML form at the HelloWorld.jsp

						
			String delete = String.format("DELETE FROM Aircraft WHERE Model_ID = '%1$s';", Aircraft);

			PreparedStatement ps = con.prepareStatement(delete);

			//Run the query against the DB
			ps.executeUpdate(); 	

			out.print("Aircraft Deleted!");
			
			//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
			con.close();

			
		} catch (Exception ex) {
			
			
			out.print("DELETE: Aircraft Not Found!");
		}
		
	}
	%> 
 
 
 
 
 
 <% String x3 = request.getParameter("push3");
	String flightNum = request.getParameter("Flight_num");
	String price = request.getParameter("Price");
	String takeoff = request.getParameter("Take_time");
	String landing = request.getParameter("Landing_time");
	String numStops = request.getParameter("Num_Stops");
	String airline = request.getParameter("Airline");
	String type = request.getParameter("Type");
	String available = request.getParameter("Available");
	String depart = request.getParameter("Depart");
	String arrive = request.getParameter("Arrive");
	
 
 if("add".equals(x3)) {
		try {

			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();

			//Create a SQL statement
			Statement stmt = con.createStatement();

			
	 		//Make an insert statement for the Sells table:
			String insert = "INSERT INTO Flight(Flight_num, price, Take_off_time, Landing_time, Num_stops, Airline, type, Available, Depart, Arrive)"
					+ "VALUES (?,?,?,?,?,?,?,?,?,?)";
			//Create a Prepared SQL statement allowing you to introduce the parameters of the query
			PreparedStatement ps = con.prepareStatement(insert);

			//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
			ps.setString(1, flightNum.toLowerCase());
			ps.setString(2, price.toLowerCase());
			ps.setString(3, takeoff.toLowerCase());
			ps.setString(4, landing.toLowerCase());
			ps.setString(5, numStops.toLowerCase());
			ps.setString(6, airline.toLowerCase());
			ps.setString(7, type.toLowerCase());
			ps.setString(8, available.toLowerCase());
			ps.setString(9, depart.toUpperCase());
			ps.setString(10, arrive.toUpperCase());
			
			//Run the query against the DB
			ps.executeUpdate(); 
			
			
			out.print("Flight Added!");
			
			
			//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
			con.close();

			
		} catch (Exception ex) {
			
			out.print("ADD ERROR: fill in all blanks to add!");
		}
   }else if("edit".equals(x3)){
	   try {

			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();

			//Create a SQL statement
			Statement stmt = con.createStatement();

			//Get parameters from the HTML form at the HelloWorld.jsp

	 		//Make an insert statement for the Sells table:
	 			
	 			
	 		String update = String.format("UPDATE Flight SET price = '%2$s', Take_off_time = '%3$s', Landing_time = '%4$s', Num_stops = '%5$s', Airline = '%6$s', type= '%7$s', Available ='%8$s', Depart = '%9$s', Arrive = '%10$s' WHERE Flight_num = '%1$s'", flightNum, price, takeoff, landing, numStops, airline, type, available, depart, arrive);

			PreparedStatement ps = con.prepareStatement(update);

			//Run the query against the DB
			ps.executeUpdate(); 
			
			
			out.print("Flight Edited!");
			
			
			//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
			con.close();

			
		} catch (Exception ex) {
			
			out.print(ex);
			
			out.print("EDIT Error: Enter all blankns!");
		}
   }else if("delete(enter Flight#)".equals(x3)){
	   try {

			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();

			//Create a SQL statement
			Statement stmt = con.createStatement();


			String delete = String.format("DELETE FROM Flight WHERE Flight_num= '%1$s'", flightNum);
					//(Flight_num = '%1$s') OR (price = '%2$s') OR (Take_off_time = '%3$s') OR (Landing_time = '%4$s') OR (Num_stops = '%5$s') OR (Airline= '%6$s') OR (type= '%7$s') OR (Available = '%8$s') OR (Depart = '%9$s') OR (Arrive = '%10$s')", flightNum, price, takeoff, landing, numStops, airline, type, available, depart, arrive);

			PreparedStatement ps = con.prepareStatement(delete);
			
			ps.executeUpdate(); 	

			out.print("Flight Deleted!");
			
			//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
			con.close();

			
		} catch (Exception ex) {
			
			
			out.print("DELETE: Flight Not Found!");
		}
		
	}
	%> 
 
 
 
 
 
 
 
 
 
 
</body>
</html>