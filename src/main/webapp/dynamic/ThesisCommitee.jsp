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
				String GET_STUDENT_QUERY = "select * from ThesisCommittee";
				// Make a connection to the driver
				Connection connection = DriverManager.getConnection
				("jdbc:postgresql:tritonlink?user=postgres&password=helloworld");
				
				Statement stmt = connection.createStatement();
				
				ResultSet rs = stmt.executeQuery(GET_STUDENT_QUERY);
				while (rs.next()) {
				%>
			<span>tc_ID is <%= rs.getInt(1) %></span><br/>
			<span>fc_name1 (sameDpt)  is <%= rs.getString(2) %></span><br/>
			<span>fc_name2 (sameDpt)  is <%= rs.getString(3) %></span><br/>
			<span>fc_name3 (sameDpt)  us <%= rs.getString(4) %></span><br/>
			<span>fc_name1 (diffDpt)  us <%= rs.getString(5) %></span><br/>
			<br/><br/><br/>
			
			<% } %>


<!-- create table student (st_id varchar(255) NOT NULL PRIMARY KEY, st_SSN varchar(255), st_enrollmentStatus varchar(255), st_residential varchar(255), st_firstName varchar(255), st_middleName varchar(255), st_lastName varchar(255)); -->

</body>
</html>

