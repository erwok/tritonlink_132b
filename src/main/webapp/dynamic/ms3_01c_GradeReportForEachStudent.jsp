<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Report Student <%= studentID %>'s Grade</title>
</head>
<body>
<%-- Set the scripting language Java and --%>
<%@ page language="java" import="java.sql.*" %>

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
	
		String GET_ ?? _QUERY = 
	        "SELECT * FROM ?? \n" + 
			"WHERE st_id = '" + studentID + "'";
		ResultSet rs = stmt.executeQuery( ?? );
	%>
	
	
	
	<table>
		<tr>
			<th></th>
		</tr>
	<%
		while (rs.next()) {    
	%>
		<tr>
			
		</tr>

	<%
		}
	%>
	</table>
	
	<%
	// Close the ResultSet
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

</body>
</html>