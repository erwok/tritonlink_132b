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
				String GET_Student_QUERY = "select * from Student";
				// Make a connection to the driver
				Connection connection = DriverManager.getConnection
				("jdbc:postgresql:tritonlink?user=postgres&password=helloworld");
				
				Statement stmt = connection.createStatement();
				
				ResultSet rs = stmt.executeQuery(GET_Student_QUERY);
				while (rs.next()) {
				%>
			<span>st_ID is <%= rs.getString(1) %></span><br/>
			<span>st_SSN is <%= rs.getInt(2) %></span><br/>
			<span>st_enrollmentStatus is <%= rs.getString(3) %></span><br/>
			<span>st_residential us <%= rs.getString(4) %></span><br/>
			<span>st_firstName us <%= rs.getString(5) %></span><br/>
			<span>st_middleName us <%= rs.getString(6) %></span><br/>
			<span>st_lastName us <%= rs.getString(7) %></span><br/>
			<br/><br/><br/>
			
			<% } %>

</body>
</html>

