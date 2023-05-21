<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Select Student</title>
</head>
<body>
<%-- Set the scripting language Java and --%>
<%@ page language="java" import="java.sql.*" %>
	<h2>Get Student's Current Classes Report</h2>
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
	%>
	
	<h4>Enter Student ID</h4>
	<table>
		<tr>
			<form action="ms3_01a_StudentCurrentClasses.jsp" method="get">
				<input type="hidden" value="enter" name="action">
				<td><input value="" name="st_ID" size="10"></td>
				<td><input type="submit" value="Enter"></td>
			</form>
		</tr>
	</table>
	

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
	
	<a href="./00_index.jsp">Back to Home Page</a>

</body>
</html>