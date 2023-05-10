<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Student home page</title>
</head>
<body>
<%-- Set the scripting language Java and --%>
			<%@ page language="java" import="java.sql.*" %>
			
			<%-- Open Connection Code --%>
				<%
				DriverManager.registerDriver(new org.postgresql.Driver());
				String GET_Class_QUERY = "select * from Class";
				// Make a connection to the driver
				Connection connection = DriverManager.getConnection
				("jdbc:postgresql:tritonlink?user=postgres&password=helloworld");
				
				Statement stmt = connection.createStatement();
				
				ResultSet rs = stmt.executeQuery(GET_Class_QUERY);
				while (rs.next()) {
				%>
			<span>cl_title is <%= rs.getString(1) %></span><br/>
			<span>cl_year is <%= rs.getInt(2) %></span><br/>
			<span>cl_quarter is <%= rs.getString(3) %></span><br/>
			<span> us <%= rs.getInt(4) %></span><br/>
			<br/><br/><br/>
			
			<% } %>

</body>
</html>

