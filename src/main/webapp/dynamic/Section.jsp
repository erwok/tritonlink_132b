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
				String GET_Section_QUERY = "select * from Section";
				// Make a connection to the driver
				Connection connection = DriverManager.getConnection
				("jdbc:postgresql:tritonlink?user=postgres&password=helloworld");
				
				Statement stmt = connection.createStatement();
				
				ResultSet rs = stmt.executeQuery(GET_Section_QUERY);
				while (rs.next()) {
				%>
			<span>s_sectionID is <%= rs.getInt(1) %></span><br/>
			<span>s_limitCapacity is <%= rs.getInt(2) %></span><br/>
			<br/><br/><br/>
			
			<% } %>

</body>
</html>

