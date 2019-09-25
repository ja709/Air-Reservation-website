<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Flights</title>
</head>
<body>
<%	out.print("Welocme to your account, ");
    out.print(session.getAttribute("name"));
    out.print("!");%>
       
<br>
<form method="post">
<table>
	<tr>    
	<td>from</td><td><input type="text" name="from" placeholder="JFK"></td>
	</tr>
	<tr>
	<td>to</td><td><input type="text" name="to" placeholder="LAX"></td>
	</tr>
	<tr>    
	<td>take off time</td><td><input type="text" name="take_off_time" placeholder="2019-08-21 11:11:00"></td>
	</tr>
	<tr>
	<td>landing time</td><td><input type="text" name="landing_time" placeholder="2019-08-22 11:11:00"></td>
	</tr>
    <tr>
	<td>price</td><td><input type="text" name="price" placeholder="500"></td>
    <td>airline</td><td><input type="text" name="airline" placeholder="delta"></td>
    <td>stops</td><td><input type="text" name="stops" placeholder="1"></td>
	</tr>
	</table>
   	   <td>flexible date</td><td><input type="checkbox" name="felixble_date" value="felxible_date"></td>
       <input type="submit" value="find_oneway" name ="button" /> 
       <input type="submit" value="find_roundtrip" name ="button" />    
        <table>
       <td>sort by price</td><td><input type="checkbox" name="sort_by_price" value="sort_by_price"></td>
       <td>sort by departure</td><td><input type="checkbox" name="sort_by_departure" value="sort_by_departure"></td>
       <td>sort by arrival</td><td><input type="checkbox" name="sort_by_arrival" value="sort_by_arrival"></td>
       </table>  
	</form>	
		<form  method='post'>
	   <td>flights to reserve</td><td><input type="text" name="flights_to_reserve" placeholder="821,123,.."></td>
       <input type="submit" value="reserve" name ="button" /> 
       </form>
       <form  method='post'>
       <input type="submit" value="history" name ="button" /> 
       <input type="submit" value="waitlist" name ="button" /> 
       <input type="submit" value="future" name ="button" /> 
       <input type="submit" value="logout" name ="button" /> 
       </form>

       

  <% 
    String x = request.getParameter("button");
   if("history".equals(x))
   {
		response.sendRedirect("history.jsp");	
   }else if("future".equals(x)){
	   response.sendRedirect("future.jsp");
   }else if("waitlist".equals(x)){
		response.sendRedirect("my_waitlist.jsp");	
	}else if("logout".equals(x)){
		session.setAttribute("name", null);
		response.sendRedirect("index.jsp");	
	}else if("reserve".equals(x)){
		try {

			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();

			//Create a SQL statement
			Statement stmt = con.createStatement();


			String flight = request.getParameter("flights_to_reserve");
							
			String[] flights_array = flight.split(",");
			
			int i = 0;
			
			String timestamp = System.currentTimeMillis() / 1000L + "";
			
			while(i < flights_array.length){
			
			String type = null;
			
			String query = String.format("SELECT * FROM AirReservationSystem7.Flight WHERE Flight_num = '%1$s'", flights_array[i]);

			ResultSet result = stmt.executeQuery(query);	
			
			if(result.next()){
				
				if(!result.getString("Available").toString().equals("0")){
						type = "F";
						
						int temp_available = Integer.parseInt(result.getString("Available").toString());
						temp_available = temp_available - 1;
						String update = String.format("UPDATE AirReservationSystem7.Flight SET Available = '%1$s' WHERE Flight_num = '%2$s'", temp_available, flights_array[i]);

						PreparedStatement ps = con.prepareStatement(update);

						//Run the query against the DB
						ps.executeUpdate(); 
							
					    String insert = "INSERT INTO Ticket(TicketID, Flight_num, AccountID, Fare)"
								+ "VALUES (?, ?, ?, ?)";
						//Create a Prepared SQL statement allowing you to introduce the parameters of the query
						ps = con.prepareStatement(insert);

						//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
						ps.setString(1, session.getAttribute("name").toString().toLowerCase() + timestamp);
						ps.setString(2, flights_array[i].toLowerCase());
					    ps.setString(3, session.getAttribute("name").toString().toLowerCase());
					    ps.setString(4, result.getString("price").toString());
						//Run the query against the DB
					    ps.executeUpdate(); 
						
						
						 insert = "INSERT INTO CustomInfo(type, Flight_num, AccountID, TicketID)"
								+ "VALUES (?, ?, ?, ?)";
						//Create a Prepared SQL statement allowing you to introduce the parameters of the query
						 ps = con.prepareStatement(insert);
			
						//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
						ps.setString(1, type.toLowerCase());
						ps.setString(2, flights_array[i].toLowerCase());
					    ps.setString(3, session.getAttribute("name").toString().toLowerCase());
					    ps.setString(4, session.getAttribute("name").toString().toLowerCase() + timestamp);
					    
						//Run the query against the DB
					    ps.executeUpdate(); 
			
					   	out.print("Reservation added for flight " + flights_array[i] + " ");

				}else{
					type = "W";
			 		//Make an insert statement for the Sells table:
					String insert = "INSERT INTO CustomInfo(type, Flight_num, AccountID)"
							+ "VALUES (?, ?, ?)";
					//Create a Prepared SQL statement allowing you to introduce the parameters of the query
					PreparedStatement ps = con.prepareStatement(insert);
		
					//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
					ps.setString(1, type.toLowerCase());
					ps.setString(2, flights_array[i].toLowerCase());
					ps.setString(3, session.getAttribute("name").toString().toLowerCase());
					//Run the query against the DB
					ps.executeUpdate(); 

					out.print("Waitlisted for flight " + flights_array[i] + " ");
				}

			
			
			}else{

				out.print("Flight " + flights_array[i] + " Not Found!");
				
			}
						
			 i++;			
			}
			
			
			//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
			con.close();

			
		} catch (Exception ex) {
			
			out.print(ex);
			
			out.print("Flight/Account Not Found!");
		}
	
	}else if("find_oneway".equals(x)){
		try {

			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();

			//Create a SQL statement
			Statement stmt = con.createStatement();

			String from = request.getParameter("from");
			String to = request.getParameter("to");
			String takeoff = request.getParameter("take_off_time");
			String landing = request.getParameter("landing_time");
			
			if(takeoff == null || "".equals(takeoff) || landing == null || "".equals(landing)){
				out.print("Take Off Time/Arrival Time Missing!");

					  
			}else{
				
				String flexible = null;
				
				try{
					 flexible = request.getParameter("felixble_date");
			
					
				}catch(Exception e){
					
					flexible = null;
					
				}
				
				String str  = null;	
				
			if(flexible == null){	
				

			 str = String.format("SELECT * FROM AirReservationSystem7.Flight WHERE Depart = '%1$s' AND Arrive = '%2$s' AND Take_off_time = '%3$s' AND Landing_time = '%4$s'", from, to, takeoff, landing);
					
			
			}else{
				
				
				
			    java.util.Date depart_date =  new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(takeoff);
			    java.util.Date arrival_date =  new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(takeoff);

				   
				Calendar cal = Calendar.getInstance();
				java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				
				cal.setTime(depart_date);
				cal.add(Calendar.DATE, -3);	
				java.util.Date deptart_dateBefore3Days = cal.getTime();	     
				String deptart_time_Before3Days = sdf.format(deptart_dateBefore3Days);
				
				cal.setTime(depart_date);
				cal.add(Calendar.DATE, +3);	
				java.util.Date deptart_dateAfter3Days = cal.getTime();
				String deptart_time_After3Days = sdf.format(deptart_dateAfter3Days);
				
				
				cal.setTime(arrival_date);
				cal.add(Calendar.DATE, -3);	
				java.util.Date arrival_dateBefore3Days = cal.getTime();	     
				String arrival_time_Before3Days = sdf.format(arrival_dateBefore3Days);
				
				cal.setTime(arrival_date);
				cal.add(Calendar.DATE, +3);	
				java.util.Date arrival_dateAfter3Days = cal.getTime();
				String arrival_time_After3Days = sdf.format(arrival_dateAfter3Days);
				

				str = String.format("SELECT * FROM AirReservationSystem7.Flight WHERE Depart = '%1$s' AND Arrive = '%2$s' AND (Take_off_time BETWEEN '%3$s' AND '%4$s') AND (Landing_time BETWEEN '%5$s' AND '%6$s')",
						from, to, deptart_time_Before3Days, deptart_time_After3Days, arrival_time_Before3Days, arrival_time_After3Days);

			
			}
			
			
			String price_filter = request.getParameter("price");
			String airline_filter = request.getParameter("airline");
			String stops_filter = request.getParameter("stops");
			
			
			if(price_filter != null && !"".equals(price_filter)){
				str = str + String.format(" AND price = '%1$s'", price_filter );
			}
			
			
			if(airline_filter != null && !"".equals(airline_filter)){
				str = str + String.format(" AND Airline = '%1$s'", airline_filter );
			}
			
			
			if(stops_filter != null && !"".equals(stops_filter)){
				str = str + String.format(" AND Num_stops = '%1$s'", stops_filter );
			}
			
					
			String sort_price = null;
			
			try{
				sort_price = request.getParameter("sort_by_price");
		
			}catch(Exception e){	
				sort_price = null;		
			}
			
			if("sort_by_price".equals(sort_price)){
				if(str.contains("ORDER BY")){
					
					str = str + " , price";

					
				}else{
					str = str + " ORDER BY price";

				}
			}
			
			
			String sort_departure = null;
			
			try{
				sort_departure = request.getParameter("sort_by_departure");
		
			}catch(Exception e){	
				sort_price = null;		
			}
			
			if("sort_by_departure".equals(sort_departure)){
				
				if(str.contains("ORDER BY")){
					str = str + " , Take_off_time";

				}else{
					str = str + " ORDER BY Take_off_time";

				}
			}
			
			
			String sort_arrival = null;
			
			try{
				sort_arrival = request.getParameter("sort_by_arrival");
		
			}catch(Exception e){	
				sort_price = null;		
			}
			
			if("sort_by_arrival".equals(sort_arrival)){
				if(str.contains("ORDER BY")){
					str = str + " , Landing_time";

				}else{
					str = str + " ORDER BY Landing_time";

				}
				
			}
			
			
			//out.print(str);
	
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
		
		
			con.close();
			
			}
			
			
		} catch (Exception ex) {
			out.print(ex);
		}
	}else if("find_roundtrip".equals(x)){
		try {

			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();

			//Create a SQL statement
			Statement stmt = con.createStatement();

			//Get parameters from the HTML form at the HelloWorld.jsp
			String from = request.getParameter("from");
			String to = request.getParameter("to");
			String takeoff = request.getParameter("take_off_time");
			String landing = request.getParameter("landing_time");
			
			String flexible = null;
			
			try{
				 flexible = request.getParameter("felixble_date");
		
				
			}catch(Exception e){
				
				flexible = null;
				
			}
			
			String str  = null;	
			
		if(flexible == null){	
			
			str = String.format("SELECT * FROM AirReservationSystem7.Flight WHERE (Depart = '%1$s' AND Arrive = '%2$s' AND  Take_off_time = '%3$s') UNION SELECT * FROM AirReservationSystem7.Flight WHERE (Depart = '%2$s' AND Arrive = '%1$s' AND Landing_time = '%4$s')",
					from, to, takeoff, landing);
							
		
		}else{
			
			
			
		    java.util.Date depart_date =  new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(takeoff);
		    java.util.Date arrival_date =  new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(takeoff);

			   
			Calendar cal = Calendar.getInstance();
			java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			
			cal.setTime(depart_date);
			cal.add(Calendar.DATE, -3);	
			java.util.Date deptart_dateBefore3Days = cal.getTime();	     
			String deptart_time_Before3Days = sdf.format(deptart_dateBefore3Days);
			
			cal.setTime(depart_date);
			cal.add(Calendar.DATE, +3);	
			java.util.Date deptart_dateAfter3Days = cal.getTime();
			String deptart_time_After3Days = sdf.format(deptart_dateAfter3Days);
			
			
			cal.setTime(arrival_date);
			cal.add(Calendar.DATE, -3);	
			java.util.Date arrival_dateBefore3Days = cal.getTime();	     
			String arrival_time_Before3Days = sdf.format(arrival_dateBefore3Days);
			
			cal.setTime(arrival_date);
			cal.add(Calendar.DATE, +3);	
			java.util.Date arrival_dateAfter3Days = cal.getTime();
			String arrival_time_After3Days = sdf.format(arrival_dateAfter3Days);
			
			str = String.format("SELECT * FROM AirReservationSystem7.Flight WHERE (Depart = '%1$s' AND Arrive = '%2$s' AND  (Take_off_time BETWEEN '%3$s' AND '%4$s')) UNION SELECT * FROM AirReservationSystem7.Flight WHERE (Depart = '%2$s' AND Arrive = '%1$s' AND (Landing_time BETWEEN '%5$s' AND '%6$s'))",
					from, to, deptart_time_Before3Days, deptart_time_After3Days, arrival_time_Before3Days, arrival_time_After3Days);
							
		}
			
			
			String price_filter = request.getParameter("price");
			String airline_filter = request.getParameter("airline");
			String stops_filter = request.getParameter("stops");
			
			
			if(price_filter != null && !"".equals(price_filter)){
				str = str + String.format(" AND price = '%1$s'", price_filter );
			}
			
			
			if(airline_filter != null && !"".equals(airline_filter)){
				str = str + String.format(" AND Airline = '%1$s'", airline_filter );
			}
			
			
			if(stops_filter != null && !"".equals(stops_filter)){
				str = str + String.format(" AND Num_stops = '%1$s'", stops_filter );
			}
			
					
			String sort_price = null;
			
			try{
				sort_price = request.getParameter("sort_by_price");
		
			}catch(Exception e){	
				sort_price = null;		
			}
			
			if("sort_by_price".equals(sort_price)){
				if(str.contains("ORDER BY")){
					
					str = str + " , price";

					
				}else{
					str = str + " ORDER BY price";

				}
			}
			
			
			String sort_departure = null;
			
			try{
				sort_departure = request.getParameter("sort_by_departure");
		
			}catch(Exception e){	
				sort_price = null;		
			}
			
			if("sort_by_departure".equals(sort_departure)){
				
				if(str.contains("ORDER BY")){
					str = str + " , Take_off_time";

				}else{
					str = str + " ORDER BY Take_off_time";

				}
			}
			
			
			String sort_arrival = null;
			
			try{
				sort_arrival = request.getParameter("sort_by_arrival");
		
			}catch(Exception e){	
				sort_price = null;		
			}
			
			if("sort_by_arrival".equals(sort_arrival)){
				if(str.contains("ORDER BY")){
					str = str + " , Landing_time";

				}else{
					str = str + " ORDER BY Landing_time";

				}
				
			}
			
			//out.print(str);

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
		
			con.close();
			
			
		} catch (Exception ex) {
			out.print(ex);
		}
	}
	
	%> 
 
</body>
</html>