<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Flights</title>
</head>
<body>

Login to your account
<br>
	<form method="post" action="login.jsp">
	<table>
	<tr>    
	<td>username</td><td><input type="text" name="username"></td>
	</tr>
	<tr>
	<td>password</td><td><input type="text" name="password"></td>
	</tr>
	<tr>
    <td>representative registration</td><td><input type="checkbox" name="is_rep" value="rep"></td>
	</tr>
	</table>
	<button type="submit">Login</button>
    <button type="submit" formaction="register.jsp">Register</button>
	<br>

	</form>
<br>
</body>
</html>