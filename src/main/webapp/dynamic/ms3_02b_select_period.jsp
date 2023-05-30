<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
String sectionID = request.getParameter("sectionID");
%>
<title>Select Desired Date Period for Section <%= sectionID %></title>
</head>
<body>
<%-- Set the scripting language Java and --%>
<%@ page language="java" import="java.sql.*, java.util.*" %>

<h2>Select Desired Date Period for Section <%= sectionID %></h2>

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
	
	<table>
		<tr>
			<th>Start Date</th>
			<th>End Date</th>
		</tr>
		<tr>
			<form action="ms3_02b_stuff.jsp" method="get">
			    <input type="hidden" value="select" name="action">
			    <input type="hidden" name="sectionID" value="<%= sectionID %>">
		        <td><input name="start" value=""></td>
		        <td><input name="end" value=""></td>
			    <td><input type="submit" value="Generate Available Times"></td>
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
	
	
	<br>
	<a href="./ms3_02b_selection.jsp">Back to section selection page</a>
	<br>
	<a href="./00_index.jsp">Back to Home Page</a>

</body>
</html>