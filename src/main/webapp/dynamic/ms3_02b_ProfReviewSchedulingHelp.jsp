<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
String fc_name = request.getParameter("fc_name");
String s_sectionid = request.getParameter("s_sectionid");
%>
<title>Professor <%= fc_name %>'s <%= s_sectionid %> Review Scheduling Help</title>
</head>
<body>
<%-- Set the scripting language Java and --%>
<%@ page language="java" import="java.sql.*, java.util.*" %>
<%@ page import="java.time.LocalTime, java.time.format.DateTimeFormatter" %>


<h2><%= fc_name %>'s <%= s_sectionid %> Review Scheduling Help</h2>

	<%
	try {
	    // Load driver
	    DriverManager.registerDriver(new org.postgresql.Driver());
	    
	    // Make a connection to the Oracle datasource
	    Connection connection = DriverManager.getConnection
		("jdbc:postgresql:tritonlink?user=postgres&password=helloworld");
	%>
	
	<%
		Statement stmt = connection.createStatement();
		ResultSet rs = null;
	%>
	
	<%
	rs.close();
	%>

	<%				
	// Close the Statement
	stmt.close();
	
	// Close the connection
	connection.close();
	
	} catch (SQLException sqle) {
	    out.println(sqle.getMessage());
	} catch (Exception e) {
	    out.println(e.getMessage());
	}
	%>
	
	
	<br>
	<a href="./ms3_02b_ProfSelectionReviewSchedulingHelp.jsp">Back to Professor selection page</a>
	<br>
	<a href="./00_index.jsp">Back to Home Page</a>

</body>
</html>