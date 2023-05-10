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
				String GET_Faculty_QUERY = "select * from Faculty";
				// Make a connection to the driver
				Connection connection = DriverManager.getConnection
				("jdbc:postgresql:tritonlink?user=postgres&password=helloworld");
				
				Statement stmt = connection.createStatement();
				
				ResultSet rs = stmt.executeQuery(GET_Faculty_QUERY);
				while (rs.next()) {
				%>
			<span>fc_name is <%= rs.getString(1) %></span><br/>
			
			<% } %>

</body>
</html>

